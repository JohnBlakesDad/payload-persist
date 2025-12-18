package CXN::Depth;

#this is a high-level module
# all arguments to methods are hashes (for sophistication)
# in the modules called within the methods,
# the arguments are arrays (for performace)

use strict ;

use lib ('/home/httpd/cgi-bin/')                         ;

# Cgi Modules
    use CXN::Cgi                                         ;
    my $cgi = new CXN::Cgi                               ;
    sub cgi { return $cgi }

# DepthDB Modules
    use CXN::DeepDB                                      ;
    my $db = new CXN::DeepDB                             ;
    sub db { return $db }

# DepthUtil Modules, tools for DeepDB
    use CXN::DepthUtil                                   ;
    my $util  = new CXN::DepthUtil                       ;
    sub util { return $util }

# Html Modules, formatting
    use CXN::Html                                        ;
    my $html = new CXN::Html                             ;
    sub html { return $html }

# Html Text Areas Modules
  # soon java based editor
    use CXN::Form                                        ;
    my $form = new CXN::Form                             ;
    sub form { return $form }

# Javascript to communicate w/ browser
    use CXN::JavaScript                                  ;
    my $javascript = new CXN::JavaScript                 ;
    sub javascript { return $javascript }

# Format URI/URL strings both ways
    use CXN::Escape                                      ;

sub new {
    # 
    my $self = {}                                        ;
    my $class = shift                                    ;
    ####
    #create strutures from browser environment
    $cgi -> get_vars                                     ;
    $cgi -> get_env                                      ;
    ####
    $self ->{debug} = undef                              ;
    bless ($self, $class)                                ;
    return ( $self )
}

sub set_db {
   # sets database requirements
   # db name, password, write permission, upd ??
   my $self = shift                                      ;
   my %arg = @_                                          ;
   my $return                                            ;
   my @def = ( 'db', 'secret', 'write', 'upd' )          ;
   my $def                                               ;
   foreach $def (@def) {
     $util -> {$def} = $arg{$def} if defined $arg{$def}  ;
     print "$def $arg{$def}<BR>" if defined $self->{debug}; 
   }
   $db -> write if $arg{'write'} eq 'yes'              ;
   $db -> db($arg{db}) if defined $arg{db}             ;
   return $return
}

sub start_html {
   my $self = shift                                      ;
   my %arg = @_                                          ;
   # howabout those little gifs 
   # I see in the URL window in the browser
   my @header_def=('title','back_ground_color','text_color',
                                        'back_ground_image' );
   my @header_args                                       ;
   foreach (@header_def) { 
     $arg{$_} = undef unless defined $arg{$_}            ;
     push ( @header_args, $arg{$_} )
   }  
   my $html_string = $html->header(@header_args)."\n"    ; 
   if ( defined $arg{'css_file'} ) {
      $html_string .= '<tmpl_include "'.$arg{'css_file'}.'">'. 
        '<LINK rel="stylesheet" href="/'.$arg{'css_file'}.'>'."\n";
   }
   return $html_string ;
}

sub depth_array {
   # this defines depth into the db structure 
   my $self = shift                                      ;
   my $depth_array                                       ;
   my $depth_string                                      ;
   my %arg = @_                                          ;
   # normally the depth array comes from the browser
   # override is an argument
   
   # normal condition, array comes from browser
   if (( defined $cgi->{'vars'}{'depth'} ) and 
      ( ! defined $arg{'override'} ))  
   {
      print "defined cgi<BR>" if $self->{debug}          ;
      $depth_string = $cgi->{'vars'}{'depth'}            ;
      @$depth_array = split (/ +/, $depth_string)        ;
      $self -> {'depth_array'} = $depth_array            ;
      $util -> {'depth_array'} = $depth_array            ;
   }
   # if a string vector is passed instead of an array
   # as an argument
   elsif (( defined $arg { 'depth_string' } ) and 
                   ( ! defined $arg { 'override' } )) 
   {
      print "UN defined cgi-string<BR> " if $self->{debug} ;
      $depth_string = $arg { 'depth_string' }            ;
      @$depth_array = split (/ +/, $depth_string)        ;
      $self -> {'depth_array'} = $depth_array            ;
      $util -> {'depth_array'} = $depth_array            ;
   }
   #if a depth array is passed as argument
   elsif (( defined $arg { 'depth_array' } ) and 
                  ( ! defined $arg { 'override' } )) 
   {
      print "UN defined cgi-array<BR> " if $self->{debug}      ;
      $depth_array = $arg { 'depth_array' }            ;
      $self -> {'depth_array'} = $depth_array          ;
      $util -> {'depth_array'} = $depth_array          ;
   }
   # override redefines the depth array
   elsif ( defined $arg { 'override' } ) 
   {
    print "OVERRIDE defined <BR> " if $self->{debug}   ;
    $depth_array = $arg { 'depth_array' }              ;
    $self -> {'depth_array'} = $depth_array            ;
    $util -> {'depth_array'} = $depth_array
   }

   else { print "No depth array\n" }
   # depthdb utils module needs to know the input from the
   # browser and arguments to access data
   $util -> {env} = $cgi -> {env}                      ;
   $util -> {vars} = $cgi -> {vars}                    ;
   return $depth_array
}

sub vector {
  # this creates the top bar for digging down into the db
  my $self = shift                                    ;
  my %arg = @_                                        ;
  my $uri                                             ;
  if ( defined $arg { 'uri' } ) {
    # This changes the name of the executable
    # ex-  "/cgi-bin/Depth.lib/"
    $uri = $arg { 'uri' } 
  }
    # or goes back to orginal script
  else { $uri = $cgi -> {'env'}{'SCRIPT_NAME'}.'/' }   ;

  ####################################
  # $util -> {env} = $cgi -> {env}                      ;
  # $util -> {vars} = $cgi -> {vars}                    ;
  # moved to depth_array method
  ####################################
  
  my $depth_array                                     ;
  if ( $arg { 'depth_array' } ) {
    $depth_array = $arg { 'depth_array' } 
  }
  # self->depth_arr is set by depth_array method
  else  { $depth_array = $self -> {'depth_array'} }   ;

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
   my $self = shift                                           ;
   # depth_array as object of array
   my %arg = @_                                               ; 
   my $depth_array = $self -> {'depth_array'}                 ;

   my $depth_string = join ( ' ', $depth_array )              ;

   my $uri = $cgi -> {'env'}{'SCRIPT_NAME'}                   ;
   my $form = new CXN::Form                                   ;
   my $return .= $form -> start_form ( undef, $uri, undef )   ;
   my $search_string = $$depth_array[$#$depth_array]          ;
   $search_string =~ s/<[^<>]*>//g                            ;
   $return .= $form -> one_line ( 'search_input', 30, 30 )    ;
   
   $self -> set_hidden_struct                                 ;  
   $form -> hidden ( $self -> {hidden_struct_string} )        ;

   $return .= $form -> hidden ( $self -> {hidden_struct_string} ) ;
   $return .= $form -> submit ( "Search $search_string" )     ;
   $return .= $form -> end_form                               ;
   return $return
}

sub mk_table {
   # gets data for table and gives it to 
   # util method
   # 
   my $self = shift                                           ;
   my $depth_array                                            ;
   my %arg = @_                                               ;
   $depth_array = $self -> {'depth_array'}                    ;
   $util -> {'base_depth_array'} = $depth_array               ;   
   # click depth makes the depth data clickable 
   if ( $arg{'click_depth'} eq 'no' ) {
     $util -> {'click_depth'} = 'no'
   }
   else { $util -> {'click_depth'} = 'yes' }

   # get data from db
   my $serialized_structure = $db -> depth ( @$depth_array )  ;
   # this is what dump.pm calls structure (no clue y)
   my $VAR1                                                   ;
   # turns string from db into structure
   my $structure = eval $serialized_structure                 ;
   
   # if this is coming from search call
   # there will be search input
   if ( $cgi->{'vars'}{'search_input'} ) {                    ;
     $util -> search($cgi->{'vars'}{'search_input'})
   }
   return $util -> mk_table ( $structure )                    ;
}

sub click_depth { $util -> {'click_depth'} = 'yes' }

sub hidden_struct {
   # the pages communicate w/ each other with hidden forms
   # a single hidden form has a string that is a 
   # serialized struture, the structure is evaled and updated
   # and serialized into a hidden form called "hidden_struct"
   # in the next method
   my $self = shift ;
   my $hidden_struct_string ;

   if ( defined $self -> cgi -> {vars}{hidden_struct} ) {
     $hidden_struct_string = $self -> cgi -> {vars}{hidden_struct} ;
     $hidden_struct_string = CXN::Escape::uri_unescape($hidden_struct_string) ;
   }
   my $VAR1 ;
   # to accomadate dump.pm
   $self -> {hidden_struct} = eval $hidden_struct_string ;

   #$pob -> pretty_print ;
   #print $html -> text ;
   #print $pob -> serialize( $self->{hidden_struct} ) if $self -> {debug}
}

sub set_hidden_struct {
  #creates hidden struct from complex structure
  my $self = shift          ;
  my $hidden_struct = shift ;
  my $hidden_struct_string  ;
  # if complex struct is passed as an array...
  if ( defined $hidden_struct ) { 
    $hidden_struct_string = $self -> serialize ( $hidden_struct ) 
  }
  # if not then use one defined in main structure
  elsif ( defined $self -> { hidden_struct } ) {
    $hidden_struct_string 
            = $self -> serialize ( $self -> { hidden_struct } )
  }
  $hidden_struct_string = CXN::Escape::uri_escape($hidden_struct_string) ;
  $self -> {hidden_struct_string} = $hidden_struct_string  ;
  return $hidden_struct_string
}

#
#since the depth module is not meant to be exclusively web
#based the skelton below serves as a guide to support
#command line (and other) applications
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
    # makes dump.pm output look better
    my $self = shift                                      ;
    my $val                                               ;
    if ( $val = shift ) { $self -> {pretty_print} = $val }  
    else { $self -> {pretty_print} = 'yes' }
    return $val 
}

sub serialize {
    # creates string from structure
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
#right now these are seperate scripts
#they need to be wrapped into methods
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
#theoretically all the sub modules called by Depth.pm
#can be methods, and here is where they would go
#  

sub DESTROY {
    my $self = shift                                            ;
}


1;
