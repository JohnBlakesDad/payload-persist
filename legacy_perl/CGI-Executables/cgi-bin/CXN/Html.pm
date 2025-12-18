package CXN::Html ;

sub new {
   my $class = shift ;
   my $self = {} ;
   bless ($self, $class) ;
   return $self  
}

sub header {
   my $self = shift ;
   ( $title, $back_ground_color, $text_color, $back_ground_image ) = @_                         ;
   my $line = "Content-Type: text/html\n\n"                                 ;
   $line .= '<HTML><HEAD>'                                                  ;
   $line .= '<TITLE>'.$title.'</TITLE>' if $title                           ;
   $line .= '<BODY'                                                         ;
   if ( $back_ground_color ) { $line .= ' BGCOLOR='.$back_ground_color }
   elsif ( $back_ground_image ) { $line .= ' BACKGROUND='.$back_ground_image }
   else { $line .= ' BGCOLOR="#FFFFFF"' }                                   ;
   $line .= ' TEXT='.$text_color if $text_color                             ;
   return $line.">\n"
}

sub font {
   my $self = shift ;
   my ( $size, $face ) = @_                                   ;
   my $line = 
         '<FONT FACE="Verdana, Arial, Helvetica, sans-serif" '; 
   $line .= 'SIZE="'.$size.'" '                                ;
   return $line .= '>'
}

sub unfont {
   return '</font>' ; 
}

sub div {
   my $self = shift ;
   my ( $align ) = @_                                          ;
   my $line =  
         '<DIV ALIGN="'.$align                                 ;
   return $line .= '">';
}

sub undiv {
   return '</DIV>' ; 
}

sub text {
   return '<PRE>'
}

sub untext {
   return '</PRE>'
}

sub end {
   my $self = shift ;
   return "</BODY> </HTML>\n"
}

1;
