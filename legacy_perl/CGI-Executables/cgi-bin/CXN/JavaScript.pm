package CXN::JavaScript ;

sub new { 
   my $self = {}                                        ;
   my $class = shift                                    ;
   bless ($self, $class)                                ;
   return ( $self );
}

sub popup_href_fxn {
   my $self = shift ;
   my $return_string = '
<script language="JavaScript">
<!--
function popup_window(Link,Name,String) {
    window.open(Link,Name,String) ;
}
// -->
</script>
';
return $return_string
}

sub popup_href {
   my $self  = shift ;
   my $thing = shift ; 
   my $href  = shift ; 
   my $name  = shift ; 

   my $return_string = "<a href=\"javascript:popup_window(\'$href\'"  ;

   if ( defined $name ) { $return_string .= ",\'$name\'" }
   else { $return_string .= ",\'\'" }
   my $arg                                                            ;
   my $arg_string = ',\''                                               ;
   foreach $arg ( 'width', 'height', 'scroll' ) { 
     $value = shift @_                                                ;
     if ( defined $value ) { $arg_string .= "$arg=$value," }
     #else { $arg_string .= "$arg= ," }
   }
   chop $arg_string                                                   ;
   $arg_string .= '\''                                                 ;
   $return_string .= $arg_string                                      ;
   $return_string .= ")\">$thing</a>"                                   ;
   return $return_string
} 

sub window_close_fxn {
   my $self = shift ;
   my $return_string = '
<script language="JavaScript">
<!--
function window_close() {
    window.close() ;
}
// -->
</script>
';
return $return_string
}


sub DESTROY {
    my $self = shift                                                  ;
}

1;
