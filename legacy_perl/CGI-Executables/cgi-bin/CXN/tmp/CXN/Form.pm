package CXN::Form ;

sub new {
   my $class = shift                        ; #This brings in the Form pkg.
   my $self = {} ;
   bless( $self, $class )                  ; #This makes self part of Form
   return $self                            ; # self goes back to caller  
}

sub start_form {
    my $self = shift                                            ;
    my ( $method, $action, $target ) = @_                       ;
    my $line = '<FORM METHOD=POST'                               ; 
    $line = '<FORM METHOD='.$method if $method               ; 
    $line .= ' ACTION="'.$action.'"' if $action              ;
    $line .= ' TARGET="'.$target.'"' if $target              ;
    $line .= ' ENCTYPE="application/x-www-form-urlencoded" >' ;
    return $line
}

sub one_line {
    my $self = shift ;
    my ( $name, $size, $maxlength ) = @_                        ;
    #must add text
    my $line = '<INPUT TYPE="text"'                             ;
    $line .= ' NAME="'     .$name     .'"' if $name             ;
    $line .= ' SIZE="'     .$size     .'"' if $size             ;
    $line .= ' MAXLENGTH="'.$maxlength.'"' if $maxlength        ;
    return $line.">\n" 
}

sub multi_line {
    my $self = shift ;
    my ( $name, $cols, $rows, $text, $wrap ) = @_                             ;
    #must add text
    my $line = '<TEXTAREA'                                      ;
    $line .= ' NAME="'.$name .'"' if $name                            ;
    $line .= ' COLS="'.$cols .'"' if $cols                            ;
    $line .= ' ROWS="'.$rows .'"' if $rows                            ;
    $line .= ' WRAP="'.$wrap .'"' if $wrap				;
    return $line.">$text</TEXTAREA>\n"
}

sub checkbox {
    my $self = shift ;
    my ( $name, $text, $checked ) = @_                              ;
    my $line = '<INPUT TYPE="checkbox"'                             ;
    $line .= ' NAME='.$name if $name                                ;
    $line .= ' CHECKED="checked"' if $checked                       ;
    return $line.">$text</INPUT>\n"
}

sub radio {
    my $self = shift ;
    my ( $name, $opt_array, $checked ) = @_                         ;
    my $line, $opt                                                  ;
    foreach $opt ( @$opt_array ) {
       $line .= "<INPUT TYPE=\"radio\" NAME=\"$name\" VALUE=\"$opt\"" ;
       $line .= " CHECKED " if $opt eq $checked ;
       $line .= ">$opt<BR>\n"
    }
    return $line."</INPUT>\n"
}

sub password {
    my $self = shift ;
    my ( $name ) = shift                                        ;
    my $line = '<INPUT TYPE="password"'                         ;
    $line .= ' NAME='.$name if $name                            ;
    return $line.">\n"
}

sub submit {
    my $self = shift ;
    my $value = shift ;
    my $line = '<input TYPE="submit" value="'.$value.'"Submit">';
    return $line 
}

sub button {
    my $self = shift ;
    my $value = shift ;
    my $image = shift ;
    my $line = '<INPUT TYPE="image" src="'.$image.
                                  ' BORDER=0 VALUE="'.$value.'>';
    return $line ;
}

sub hidden { 
   my $self = shift ;
   my ( $name, $value ) = @_                                    ;
   my $line .= '<INPUT TYPE="hidden"'                           ;
   $line .= ' NAME="'.$name.'"'   if $name                      ;
   $line .= ' VALUE="'.$value.'"' if $value                     ;
   return $line.'>'
}

sub hidden_struct {
#not used yet
   my $self = shift ;
   my $name = shift ;
   foreach $key ( shift ) {
    $hidden_struct -> {$key} = shift ; 
   }                 
   # Get this from Depth.pm, reverse inheritance
   #use CXN::PersistOB ;
   #my $pob = new CXN::PersistOB  ;
   $hidden_struct_str = $pob -> serialize ( $hidden_struct )            ;
   return $self -> hidden ( 'hidden_struct' , $hidden_struct_str )

}

sub end_form {
    my $self = shift ;
    return '</FORM>'
}

1;
