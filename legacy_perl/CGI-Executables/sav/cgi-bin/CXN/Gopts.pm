package CXN::Gopts ; 

my $self;
use strict;

sub gopts {

   my $opt='def' ;

   my $arg ;

   foreach $arg ( @ARGV ) {
     if ( $arg !~ /^-(\S*)/ ) { 
       push ( @{$self -> {'opt_data'}{$opt}}, $arg ) ;
     }
    else { $opt=$1 ; $self -> {'opt_data'}{$opt} = []  };
   }
}

sub set_opts {

&gopts ;

my ( $key, $str )  ;
foreach $key ( keys %{$self -> {'opt_data'}} )
    { 
      $str .= " \$opt_$key=\"" ;
      if ( $#{$self -> {'opt_data'}{$key}} > -1 ) {
      foreach ( @{$self -> {'opt_data'}{$key}} )  
        { $str .= "$_ " ; }; 
       chop $str ;
      }
      else { $str .= "yes" }
      $str .= '"; ' 
    }  
  return $str ;
}

 
sub set_shell_opts {

&gopts ;

my ( $key, $str )  ;
foreach $key ( keys %{$self -> {'opt_data'}} )
    { 
      $str .= "opt_$key=\"" ;
      if ( $#{$self -> {'opt_data'}{$key}} > -1 ) {
      foreach ( @{$self -> {'opt_data'}{$key}} )  
        { $str .= "$_ " ; }; 
       chop $str ;
      }
      else { $str .= "yes" }
      $str .= '"; ' 
    }  
  return $str ;
  print $str ;
}

1;
