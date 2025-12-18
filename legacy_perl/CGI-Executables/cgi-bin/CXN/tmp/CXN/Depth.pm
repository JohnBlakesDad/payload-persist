package CXN::Depth;

use strict ;

use lib ('/home/httpd/cgi-bin/')       ;

    use CXN::Cgi                                         ;
    my $cgi = new CXN::Cgi                               ;
    sub cgi { return $cgi }

    use CXN::DeepDB                                      ;
    my $db = new CXN::DeepDB                             ;
    sub db { return $db }

    use CXN::DepthUtil                                   ;
    my $util  = new CXN::DepthUtil                       ;
    sub util { return $util }

    use CXN::Html                                        ;
    my $html = new CXN::Html                             ;
    sub html { return $html }

    use CXN::Escape                                      ;

sub new {
    my $self = {}                                        ;
    my $class = shift                                    ;
    ####
    #
    ####
    #
    ####
    bless ($self, $class)                                ;
    return ( $self )
}

sub set_db {
   my $self = shift                                                          ;
   my %arg = @_                                                              ;
   my @def = ( 'db', 'secret', 'write' )                                     ;
   if ( defined $arg{'db'} ) {
      $db -> db ( $arg{'db'} )
   }
   else { my $return = $db -> db }                                           ; 
   foreach (@def) {
     $util -> {$_} = $arg{$_} if defined $arg{$_}                ;
   }
}

sub start_html {
   my $self = shift                                      ;
   my %arg = @_                                          ;
   $cgi -> get_vars                                      ;
   $cgi -> get_env                                       ;
   my @header_def=('title','back_ground_color','text_color',
                   'back_ground_image' )                 ;
   my @header_args                                       ;
   foreach (@header_def) { 
     $arg{$_} = undef unless defined $arg{$_}            ;
     push ( @header_args, $arg{$_} )
   }  
   my $html_string = $html->header(@header_args)."\n" ; 
   if ( defined $arg{'css_file'} ) {
      $html_string .= '<tmpl_include "'.$arg{'css_file'}.'">'. 
        '<LINK rel="stylesheet" href="/'.$arg{'css_file'}.'>'."\n";
   }
   return $html_string ;
}

#sub depth_array {
#   my $self = shift                                      ;
#   my $depth_array                                       ;
#   my $depth_string                                      ;
#   my %arg = @_                                          ;
#
#
#   if ( defined $arg{'depth_array'} ) {
#    $depth_array = $arg{'depth_array'}                   ;
#    #depth_array comes in as an object in first arg
#     $self -> {'depth_array'} = $depth_array             ;
#     $util -> {'depth_array'} = $depth_array
#   }
#   elsif ( ! defined $self -> {'depth_array'} ) {
#     if ( (defined $arg{'default_array'})     
#           and ( ! defined $cgi->{'vars'}{'depth'} ) ) {
#        #print "using default array<BR>" ;
#        $depth_array = $arg{'default_array'};
#        $self -> {'depth_array'} = $depth_array             ;
#        $util -> {'depth_array'} = $depth_array
#     }
#     else {
#        #print "getting cgi vars depth string" ;
#        $depth_string = $cgi->{'vars'}{'depth'}          ;
#        @$depth_array = split (/ +/, $depth_string)         ;
#        $self -> {'depth_array'} = $depth_array             ;
#        $util -> {'depth_array'} = $depth_array
#     }
#   }
#   else { 
#     $depth_array = $self -> {'depth_array'} ;
#   }      ;
#   return $depth_array
#}

sub depth_array {
   my $self = shift                                      ;
   my $depth_array                                       ;
   my $depth_string                                      ;
   my %arg = @_                                          ;
  if (( defined $cgi->{'vars'}{'depth'} ) and 
  # if ( defined $cgi->{'vars'}{'depth'} )  
      ( ! defined $arg{'override'} ))  
   {
    print "defined cgi<BR> " ;
      $depth_string = $cgi->{'vars'}{'depth'};
      @$depth_array = split (/ +/, $depth_string)         ;
      $self -> {'depth_array'} = $depth_array ;
      $util -> {'depth_array'} = $depth_array;
  }
  elsif ( defined $arg { 'depth_string' } ) {
      print "UN defined cgi<BR> " ;
      $depth_string = $arg { 'depth_string' }  ;
      @$depth_array = split (/ +/, $depth_string)         ;
      $self -> {'depth_array'} = $depth_array             ;
      $util -> {'depth_array'} = $depth_array ;
  }
  else { print STDERR "No depth array\n" }
  return $depth_array
}

sub vector {
  my $self = shift                                    ;
  my %arg = @_                                        ;
  my $uri                                             ;
  $uri = $cgi -> {'env'}{'SCRIPT_NAME'}.'/'           ;
  $util -> {env} = $cgi -> {env}                      ;
  $util -> {vars} = $cgi -> {vars}                    ;
  my $depth_array = $self -> {'depth_array'}          ;

  my $level ;
  my $string = $uri.'?depth='                         ;
  my $print_string                                    ;
  my $out_string                                      ;
  foreach $level (@$depth_array) {
    $string .= $level." "                             ;
    $out_string .= "<a href=".uri_escape ( $string ) ." > $level > </a>"  ;
  }
  return $out_string
}

sub search {
   my $self = shift                                   ;
   # depth_array as object of array
   my $depth_array                                    ;
   my %arg = @_                                          ;
   if ( defined $arg{'depth_array'} ) {
      $self -> depth_array( $arg{'depth_array'} )
   }
   else { $depth_array = $self -> depth_array }   ; 

   my $depth_string = join ( ' ', $depth_array )      ;
   my $search_string = $$depth_array[$#$depth_array]  ;
   $search_string =~ s/<[^<>]*>//g;
   my $return_string = " <FORM METHOD=POST ACTION=\"/cgi-bin/Depth/\" ENCTYPE=\"application/x-www-form-urlencoded\" >
<INPUT TYPE=\"text\" NAME=\"search_input\" >
<INPUT TYPE=\"hidden\" NAME=\"depth\" VALUE=\"$depth_string\">
<INPUT TYPE=\"submit\" VALUE=\"Search $search_string \">
</FORM> " ;
   return $return_string
}

sub mk_table {
   my $self = shift ;
   my $depth_array ;
   my %arg = @_                                          ;
   #if ( defined $arg{'depth_array'} ) { 
   #   $self -> depth_array ( $arg{'depth_array'} )                ;
   #}
   #else { $depth_array = $self -> {'depth_array'} }
   $depth_array = $self -> {'depth_array'}  ;
   $util -> {'base_depth_array'} = $depth_array ;   
   if ( $arg{'click_depth'} eq 'no' ) {
     $util -> {'click_depth'} = 'no'
   }
   else { $util -> {'click_depth'} = 'yes' }

   my $serialized_structure = $db -> depth ( @$depth_array )      ;
   my $VAR1                                                ;
   my $structure = eval $serialized_structure                     ;
   if ( $cgi->{'vars'}{'search_input'} ) {                    ;
     $util -> search($cgi->{'vars'}{'search_input'})
   }
   return $util -> mk_table ( $structure )      ;
}

sub click_depth { $util -> {'click_depth'} = 'yes' }

sub set_upd { 
   $util -> {'upd'} = 'yes' ;
   $util -> {'secret'} = shift ;
}


#
#               ########################################
#               #                                      #
#               #    -*- DepthDB Methods Below -*-     #
#               #                                      #
#               ########################################
#
#
#sub db {
#    my $self = shift                                     ;
#    $type = shift                                        ;
#    return $self -> {'db'} -> db( $type )
#}         
#
#sub layer {
#    my $self = shift                                     ;
#    return $self -> {'db'} -> layer(@_)
#}
#
#sub depth {
#    my $self = shift                                     ;
#    return $self -> {'db'} -> depth(@_)
#}
#
#sub upd {
#    my $self = shift                                     ;
#    return $self -> {'db'} -> upd(@_)
#}
#
#sub del {
#    my $self = shift                                     ;
#    return $self -> {'db'} -> del(@_)
#}
#
#sub write {
#    my $self = shift                                     ;
#    return $self -> {'db'} -> write
#}
#
sub pretty_print {
    my $self = shift                                      ;
    my $val                                               ;
    if ( $val = shift ) { $self -> {pretty_print} = $val }  
    else { $self -> {pretty_print} = 'yes' }
    return $val 
}

sub serialize {
    my $self = shift                                      ;
    my $thing = shift ;
    #my $thing = $self -> {"$thing"}                      ;
    use Data::Dumper                                      ;
    my $dump_str1 = Data::Dumper->new([$thing])           ;
    $dump_str1 ->Indent(0) if $self -> {pretty_print} ne 'yes'     ;
    $dump_str1 ->Names([$self -> {dump_name}])
                        if $self -> {dump_name} ne ''     ;
    my $ret                                               ;
    $ret = $dump_str1->Dumpxs                             ;
    return $ret
}
#
#               #########################################
#               #        HTML Methods Below             # 
#               #                                       #
#               #    -*-  Depth , Edit, Upd     -*-     #
#               #         from Binaries                 #
#               #                                       #
#               #########################################
#
#sub Depth {
#
#}
##
#sub Upd {
#
#}
#
#sub Edit {
#
#}
#
#sub Edit_Object {
#
#}
#
#sub Upd_Object {
#
#}
#
#               #########################################
#               #                                       #
#               #    -*-   HTML Utilites Below   -*-    #
#               #                                       #
#               #########################################
#
#sub get_cgi_structures {
#   my $self = shift                                    ;
#}

sub DESTROY {
    my $self = shift                                            ;
}


1;
