package CXN::Cgi ; 

sub new {
   my $class = shift            ;
   my $self = {}                ;
   bless ( $self, $class )      ;
   return $self 
}

sub serialize {
      # note: this seems to end the page at the html level 
   my $self = shift             ;
   my $thing = shift            ;
   use CXN::PersistOB           ;
   my $ser = new CXN::PersistOB ;
   $ser -> pretty_print         ;
   return "<PRE>".$ser -> serialize( $thing )."</PRE>" ;
}

sub get_vars {
   my $self = shift             ;
   my ( $in, %in, $name, $value ) ;

   if ( defined $ENV{'REQUEST_METHOD'} 
              and ( ($ENV{'REQUEST_METHOD'} eq 'GET') ||
         ($ENV{'REQUEST_METHOD'} eq 'HEAD') ) ) {
        $in= $ENV{'QUERY_STRING'} ;

    }
    elsif ( ( defined $ENV{'REQUEST_METHOD'}) 
                && ($ENV{'REQUEST_METHOD'} eq 'POST') ) {
      if ($ENV{'CONTENT_TYPE'}=~ m#^application/x-www-form-urlencoded$#i) {
            read(STDIN, $in, $ENV{'CONTENT_LENGTH'}) ;
      }
    }

    # Resolve and unencode name/value pairs into %in

    if ( defined $in ) {
       my @in = split ('&', $in) ;
       foreach (@in) {
           s/\+/ /g ;
           ($name, $value)= split('=', $_, 2) ;
           $name=~ s/%(..)/chr(hex($1))/ge ;
           $value=~ s/%(..)/chr(hex($1))/ge ;
           $in{$name}.= "\0" if defined($in{$name}); # concatenate multiple vars
           $in{$name}.= $value ;
           #$in{$name} 
                   #=~ s/(\;|exec|\\|\`|\'|\>|\!|\||\&|\(|\$|\{|\[)//g ;
                   #=~ s/(\;|exec|\\|\`|\'|\!|\||\&|\(|\$|\{|\[)//g ;
                   #bunch o paranoia
           $self -> {'vars'}{$name} = $in{$name} ;
    }
    }
}

sub get_env {

   my $self = shift ;
   my @env = ( REQUEST_METHOD, HTTP_REFERER, HTTP_USER_AGENT, 
               REMOTE_PORT,    SCRIPT_NAME,  SCRIPT_FILENAME, 
               REQUEST_URI,    SERVER_PORT,  HTTP_EXTENSION, 
               CONTENT_TYPE,   CONTENT_LENGTH , QUERY_STRING )  ;

   my $env ;
   foreach $env (@env) { 
     my $env_val = $ENV{$env} ;
     #$env =~ s/\;//g ;
     $self -> {'env'}{$env} = $env_val 
   }
   
   if ( defined $self -> {'env'}{'REQUEST_URI'} ) { 
      my @uri = split ('/', $self -> {'env'}{'REQUEST_URI'})       ;
      ( $path, $query ) = split ( '\?', $uri[$#uri] )              ; 
      $self -> {'vars'}{'script'}  = $self -> {'env'}{SCRIPT_NAME} ;
      $self -> {'vars'}{'path'}  = $path                           ;
      $self -> {'vars'}{'query'} = $query                          ;
   }

}                                                         

sub make_my_uri {
    my $self = shift ;
    my $script = $self -> {'vars'}{'script'}                    ;
    my $path = $self -> {'vars'}{'path'}                        ;
    my $line = $script.'/'.$path.'?'                            ;
    my %vals = @_                                               ;
    foreach ( keys %vals ) {
       $line .= $_.'='.$val{$key}                               ; 
    }
    return $line 
}

sub header {
   my  $self = shift ;
   return "Content-Type: text/html\n\n";   
}

1;
