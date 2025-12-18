package CXN::DepthUtil ;

use CXN::Table  ;
use CXN::PersistOB  ; 
my $pob = new CXN::PersistOB ;
use URI::Escape ;
#use FileHandle ;

sub new {
    my $class = shift                                             ; 
    my $self = {}                                                 ;
    $self -> {'cgi'}{'vars'} = shift                           ;
    bless ($self, $class)                                         ;
    return ( $self )
}

sub mk_table {
    my $self = shift                                              ;
    my $thing = shift                                             ; 

    $self -> descend( $thing, 'dont stop' )                       ;

    if (  $self -> { 'search' } ) {
       $self -> search_arrs ( $self -> { 'search' })              ;
    }

    $self -> fmt_arr                                              ;

    my $table = new CXN::Table                                     ;
    $ret = $table -> gen_tables( $self -> {arr_stack} )            ;
    return $ret 
}

sub descend {
  my $self = shift                                                ;
  my $thing = shift                                               ;
  my $instr = shift                                                ;

  my $ref_thing = ref $thing ;
   if ( $ref_thing eq 'HASH' ) {   
                 #if it is a hash push each key into the tmp arrays
                 #and descend into the hash
      my @thing_keys = sort keys %$thing                               ;
      #print join (' ',@thing_keys)."\n"                     ;
      foreach $key ( @thing_keys ) {
        if (( $key !~ /<STOP\/*>/i ) 
           or ( $instr eq 'dont stop' )
           or ( defined $self -> {'search'} )) {
          push(@{$self -> {tmparr}}, $key)                          ;
          my $depth_array = [ @{$self -> {depth_arr}}, @{$self -> {tmparr}} ] ; 
          my $cell_string 
            = $self -> object_cell_string ( 'value'       => $key,
                                            'depth_array' => $depth_array,
                                            'type'        => 'object'
                                          );

          push(@{$self -> {pr_tmparr}}, $cell_string)               ;
          $self -> descend($thing -> {$key});
        }
        else { 
          my @pr_arr = @{$self -> {pr_tmparr}}                        ;
          #push(@{$self -> {tmparr}}, $key)                          ;
          my $depth_array = [ @{$self -> {depth_arr}}, @{$self -> {tmparr}},$key ] ; 
          my $cell_string
            = $self -> cell_string ( 
                 $key." <img src=/images/handright.gif border=0 align=right>", $depth_array, undef, 'test' );               
          push(@pr_arr, $cell_string)                                    ;
          push(@{$self -> {arr_stack}}, \@pr_arr)                     ;
        }
      }
   }
   elsif ( $ref_thing eq 'ARRAY' ) {
                 #if it is an array then you are at the data
                 #make perm print array from tmp print array 
                 #and push values into print array
      my $key = undef ;
      my @pr_arr = @{$self -> {pr_tmparr}}                        ;
      #my $depth_arr = [ @{$self -> {depth_arr}}, @{$self -> {tmparr}},$key ] ; 
      my $depth_array = [ @{$self -> {depth_arr}}, @{$self -> {tmparr}} ] ; 
      $cell_string = join("<BR><BR>", @$thing)                ;
      $cell_string
             .= $self -> cell_string (
                 #$key, $depth_arr, undef, 'test', 'passwd' );
                 $key, $depth_array, 'data' );

      $cell_string .= "array"if $debug;

      push(@pr_arr, $cell_string)                                    ;
      push(@{$self -> {arr_stack}}, \@pr_arr)                     ;
   }
   else {  
                 #if it is an array then you are at the data
                 # it must be a scalar, same as array
      my $key = undef ;
      my @pr_arr = @{$self -> {pr_tmparr}}                        ;
      #my $depth_arr = [ @{$self -> {depth_arr}}, @{$self -> {tmparr}},$key ] ; 
      my $depth_array = [ @{$self -> {depth_arr}}, @{$self -> {tmparr}} ] ; 
      my $cell_string = $thing ;
      $cell_string
             .= $self -> cell_string (
                 #$key, $depth_arr, undef, 'test' );
                 $key, $depth_array, 'data' );

      push(@pr_arr, $cell_string )                                      ;
      push(@{$self -> {arr_stack}}, \@pr_arr)                     ;
   }
  pop(@{$self -> {tmparr}})                                       ;
  pop(@{$self -> {pr_tmparr}})
 #}
} #descend

sub cell_string {
   my $self = shift ;
   my ( $value, 
        $depth_array, 
        $upd, 
        #$db, 
        #$depth_stop, 
        #$hidden_struct, 
        #$graphics_arr, 
        #$font_arr,
        #$secret, 
                      ) = @_                                      ;
   my $cell_string = '<a href=/cgi-bin/Depth.new/?'                   ;
   my $depth_string = join (' ', @$depth_array )                    ;
   $depth_string = uri_escape ( $depth_string )                   ;
   $cell_string .= 'depth='. $depth_string."XX"                        ;
   $cell_string .= '&db='. $self -> {'db'}                        ;
   #$cell_string .= '&db='.$db  if $db                            ;
   #$cell_string .= '&secret='.$secret if $secret                 ;
   $cell_string .= '>'.$value.'</a>'                              ;
   if ( $self -> {upd} eq 'yes' and defined $upd ) {
        $hidden_struct -> {'depth'} = $depth_string               ;
        $hidden_struct -> {'db'} = $self -> {'db'}                ;
        $hidden_struct -> {'secret'} = $self -> {'secret'}        ;
        $hidden_struct_str = $pob -> serialize($hidden_struct)    ;

        $cell_string .= " 
    <FORM METHOD=\"POST\" ACTION=\"/cgi-bin/Edit\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_ctls\">";

        $cell_string .= " 
   <INPUT TYPE=\"hidden\" NAME=\"hidden_struct\" VALUE=\"$hidden_struct_str\">";
        $cell_string .= " 
    <INPUT TYPE=\"submit\" NAME=\"Update Field\" VALUE=\"Edit\"></FORM>";

   }
   return $cell_string
}

sub object_cell_string {
   my $self = shift ;
   my $arg ; %$arg = @_ ;
   my $def = [ 'value', 'depth_array', 'type', 'db', 'secret',  
               'hidden_struct', 'graphics_array', 'font_array'  ]   ;
    
   my $cell_string = '<a href='.$self->{vars}{script}.'/?'          ;
   my $depth_string 
            = join (' ', @{$self -> {'base_depth_array'}}, 
                                      @{$arg -> {'depth_array'}} )  ;
   $cell_string .= "depth=".uri_escape ( $depth_string )     ;
   $cell_string .= '&db='. $self -> {'db'}                          ;
   #$cell_string .= '&db='.$db  if $db                              ;
   #$cell_string .= '&secret='.$secret if $secret                   ;
   $cell_string .= '>'.$arg -> {'value'}.'</a>'                     ;

   #xxxxx
   #$depth_string = split (/ +/, $arg -> {'depth_array'})       ;

   if ( $self -> {'upd'} eq 'yes' ) {
        $hidden_struct -> {'depth'} = $depth_string               ;
        $hidden_struct -> {'db'} = $self -> {'db'}                ;
        $hidden_struct -> {'secret'} = $self -> {'secret'}        ;
        $hidden_struct_string = $pob -> serialize($hidden_struct) ;

     if ( $arg -> {'type'} eq 'object' ) { 
        $cell_string .= "
    <FORM METHOD=\"POST\" ACTION=\"/cgi-bin/Edit_Object\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_ctls\">";
        $cell_string .= "
   <INPUT TYPE=\"hidden\" NAME=\"hidden_struct\" VALUE=\"$hidden_struct_string\">";
        $cell_string .= "
    <INPUT TYPE=\"submit\" NAME=\"Edit_Objects\" VALUE=\"Edit_Objects\"></FORM>";
     }
     elsif ( $arg -> {'type'} eq 'text' ) {
     #
     # text edit stuff
     #
     }
   }
   return $cell_string ;
}

sub _uri_escape {
   my $self = shift ;
   my $thing = shift ;
#   if (( ref $thing eq 'ARRAY' ) or ( ref $thing eq 'HASH' )) {
#     $thing = &_serialize($thing) ; 
#   }
   return uri_escape($thing) 
}

sub _serialize {
   my $self = shift ;
   my $thing = shift ;
   return $self -> {persist} -> serialize($thing) ; 
}
   
sub fmt_arr {
   my $self = shift                                         ;
   my $arr                                                  ;
   foreach $arr (@{$self -> {arr_stack}}) {
     my @sav_arr = @$arr                                    ;
     my $last_arr = $self -> {last_arr}                     ;
     my $cnt = 0                                            ;
     $arr_len = $#$arr                                       ;
     my $off_flag ;
     foreach ( @$arr ) {
       if ( $last_arr -> [$cnt] eq $arr -> [$cnt] ) {
         $arr -> [$cnt] = undef if $off_flag ne 'yes'        ;
       } 
       else { $off_flag = 'yes' }
       $cnt++                                               ;
     }
     @{$self -> {last_arr}} = @sav_arr                      ;
     $arr_num = @$arr                                       ;
   }
   push( @{$self -> {out_stack}}, $arr)  
}

sub search {
   my $self = shift ;
   my $search = shift;
   $self -> {'search'} = $search if $search ne '' ;
          # This is to prevent null searches matching everything
}

sub search_arrs {
   my $self = shift ;
   my $search = shift ;
   my $search_hit_stack   ;
   foreach $arr (@{$self -> {arr_stack}}) {
     my @search_arr;
     if ( grep /$search/i, @$arr ) {
       my $cnt = 0 ;
       while ( $cnt < $#$arr ) {
         $$arr[$cnt] =~ 
         s/(>)([^<>]*)($search)([^<>]*)(<)/$1$2<font color=orangered>$3<\/font>$4$5/ig ;
         $cnt++
       }
       $$arr[$#$arr] =~ s/($search)/<font color=orangered>$1<\/font>/gi 
         if $$arr[$#$arr] !~ /href/i ;
       push( @$search_hit_stack, $arr)
     }
   }
   $self -> {arr_stack} = $search_hit_stack   ;
}

sub depth2uri {
    my $self = shift                                            ;
    my $depth_str = shift                                       ;
    return uri_escape($depth_str)
}

sub DESTROY {
    my $self = shift ;
}

1;
