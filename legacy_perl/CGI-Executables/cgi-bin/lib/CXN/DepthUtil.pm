package CXN::DepthUtil;

use Table ;

print "XXXXXXXXXXXX"
sub new {
    my $self = {}                                        ;
    my $self -> {'tag'} = "XXX" ;
    my $class = shift                                    ;
    #$self -> {table_title} = 'yes' ; 
    bless ($self, $class)                                ;
    return ( $self )
}

sub mk_table {
    my $self = shift                       ;
    my $assc_arr = $self -> {assc_arr}     ;
    my $arr_stack = []                     ;
    my @areas = @_                         ;
    my $num = @areas                       ;
    push(@{$self -> {tmparr}}, $self -> {descend_title}  ) 
                if $self -> {table_title} eq 'yes' ; 
    if ( ref $assc_arr eq 'HASH' ) { $self -> descend($assc_arr) }
    elsif ( ref $assc_arr eq 'ARRAY' ) { 
      my $str = join('<BR>', @$assc_arr )                  ;
      push(@{$self -> {arr_stack}}, [ $str ]) 
    }                                                      
    else {  push(@{$self -> {arr_stack}}, [ $assc_arr ]) } ;
    $self -> fmt_arr ;
   
    my $table = new Table;
    $table->{content} = [ {contentstyle->['font color=white','i'],
                        style=>'bgcolor=blue',
                        content=>['Name','Phone Number']
                        }
                        ]                                   ;
    #print $self -> dump($self -> {out_stack})               ;
    push (@{$table->{content}}, @{$self -> {out_stack}})    ;
    $ret = $table->generate()                               ;
    $table = ''                                             ;
    return $ret 
  
}

sub generate_table {

    my $self = shift                                         ;
    $self -> fmt_arr                                         ;

    my $table = new Table;
    $table->{content} = [ {contentstyle->['font color=white','i'],
                        style=>'bgcolor=blue',
                        content=>['Name','Phone Number']
                        }
                        ]                                     ;
    #push (@{$table->{content}}, @{$self -> {out_stack}})      ;
    push (@{$table->{content}}, @{$self -> {arr_stack}})      ;
    $ret = $table->generate()                                 ;
    $table = ''                                               ;
    return $ret
}


sub descend {
  my $self = shift                                                ;
  my $struct = shift                                              ;
  foreach $key ( sort keys %{$struct} ) { 
    $ref_thing = ref $struct -> {$key}                            ;
    $depth_str = ' '.join(' ', @{$self -> {tmparr}})              ;
    if ( $ref_thing eq 'HASH' ) {
      push(@{$self -> {tmparr}}, $key)                            ;
      my $cell_str                                                ;
      if ( $self->{'click_depth'} eq 'yes' ) {
        my $adon_dep_str = ' '.join(' ', @{$self -> {tmparr}})    ;
        my $depth_str = $self -> {out_depth_str}." $depth_str $key";
        my $db = $self -> {db}                                    ;
        $adon_dep_str = uri_escape($adon_dep_str)                 ;
        my $url_path = $self -> {url_path}                        ;
        $url_path =~ s/(^.*\?depth_str=[^\&]*)(\&.*$)/$1$adon_dep_str$2/;
        $cell_str = "<a href=$url_path>$key</a>"                  ;
        #print $depth_str." depstr <BR>"                   ;
        $new_ob_depth_str = $depth_str                               ;
        @new_ob_depth_arr = split(/ +/, $new_ob_depth_str)           ;
        pop @new_ob_depth_arr                                         ;
        #push (@new_ob_depth_arr, $key)                                  ;
        $new_ob_depth_str = join (' ', @new_ob_depth_arr)               ; 
        #print $new_ob_depth_str." new ob depstr <BR>"                   ;
        if ( $self -> {upd} eq 'yes' ) {
          $multi_line =
            "<FORM METHOD=\"POST\" ACTION=\"/cgi-bin/depth/upd\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_canvas\">"           ;
          $multi_line
            .= "<BR><TEXTAREA NAME=\"upd $db $new_ob_depth_str \" ROWS=\"5\" >$key</TEXTAREA><BR><INPUT TYPE=\"submit\" VALUE=\"new_ob\" NAME=\"upd_chkbx\" ></FORM>" ;
          $cell_str .= $multi_line ;
        }
      }
      else { $cell_str = $key }                                   ;
      push(@{$self -> {pr_tmparr}}, $cell_str)                    ;
      $self -> descend($struct -> {$key})                          ;
    }
    else {
     my @pr_arr = @{$self -> {pr_tmparr}}                         ;
     if ( $self->{'click_depth'} eq 'yes' ) {
      my $adon_dep_str = ' '.join(' ', @{$self -> {tmparr}})." $key"   ;
      $adon_dep_str = uri_escape($adon_dep_str)                        ;
      my $url_path = $self -> {url_path}                               ;
      my $db = $self -> {db}                                           ;
      my $depth_str = $self -> {out_depth_str}." $depth_str $key";
      $url_path =~ s/(^.*\?depth_str=[^\&]*)(\&.*$)/$1$adon_dep_str$2/ ;
      $cell_str = "<a href=$url_path>$key</a>"                    ;

      if ( $self -> {upd} eq 'yes' ) {
        $cell_str .= 
       "<FORM METHOD=\"POST\" ACTION=\"/cgi-bin/depth/del\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_canvas\"><BR><INPUT TYPE=\"image\" SRC=\"/images/delete.gif\" NAME=\"del $db $depth_str null\"></FORM>";
         $multi_line =
            "<FORM METHOD=\"POST\" ACTION=\"/cgi-bin/depth/upd\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_canvas\">"           ;
         $multi_line
            .= "<TEXTAREA NAME=\"upd $db $depth_str \" ROWS=\"5\" >$key</TEXTAREA><BR>New_Object<input TYPE=\"radio\" VALUE=\"new_last_ob\" NAME=\"upd_chkbx\" ><BR>Extend_Object<input TYPE=\"radio\" VALUE=\"new_ext_last_ob\" NAME=\"upd_chkbx\"><BR><INPUT TYPE=\"submit\" VALUE=\"Update\"></FORM>" ;
         $cell_str .= $multi_line ;
      }
     }
     else { $cell_str = $key }                                    ;
     push(@pr_arr, $cell_str)                                     ;
     if ( $self -> {upd} ne 'yes' ) {
      if ( ref $struct -> {$key} eq 'ARRAY' ) {
        $struct -> {$key} = join("<BR>", @{$struct -> {$key}}) 
      }
     push(@pr_arr, $struct -> {$key}) 
     }
     else {  
       my $cell_str                                               ;
       my $depth_str = $self -> {out_depth_str}." $depth_str $key";
       my $db = $self -> {db}                                     ;
       if ( ref $struct -> {$key} eq 'ARRAY' ) {
        $pr_key = join ("\n",  @{$struct -> {$key}})           ;            
       }
       else { $pr_key = $struct -> {$key} }
          $multi_line = 
            "<FORM METHOD=\"POST\" ACTION=\"/cgi-bin/depth/upd\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_canvas\">"           ;
          $multi_line  
          .= "<TEXTAREA NAME=\"upd $db $depth_str\" ROWS=\"5\" >$pr_key</TEXTAREA><BR><INPUT TYPE=\"submit\" VALUE=\"Update\"></FORM>"                             ;
          $cell_str =  $multi_line ;
       push(@pr_arr, $cell_str)                                   ;
     }
     push(@{$self -> {arr_stack}}, \@pr_arr)
    }
  }
  pop(@{$self -> {tmparr}})                                       ;
  pop(@{$self -> {pr_tmparr}})                                    ;
} #descend


sub fmt_arr {
my $self = shift                                          ;
@tmp = @{$self -> {'depth_arr'}}                          ;
$depth_str_len = @tmp                                     ;
$header_arr_num = $self -> {header_arr_num}               ;
$blankout = 'no'                                          ;
foreach $arr (@{$self -> {arr_stack}}) {
   my @sav_arr = @$arr                                    ;
   my $last_arr = $self -> {last_arr}                     ;
   my $cnt = 0                                            ;
   $arr_len = @$arr                                       ;
   $arr_len--                                             ;
   foreach (@$arr) {
    #next if $arr_len == $cnt                             ;
    if ( $last_arr -> [$cnt] eq $arr -> [$cnt] ) {
     #$arr -> [$cnt] = undef                              ;
     $arr -> [$cnt] = ''                                  ;
    }
    $cnt++                                                ;
   }
   @{$self -> {last_arr}} = @sav_arr                      ;
   $arr_num = @$arr                                       ;
   $spl_num = $header_arr_num  - $arr_num      ; 
   #print "$header_arr_num $arr_num<BR>" ; 
   if ( $header_arr_num > 0 ) {
    if ( $spl_num < 0 ) {
     splice(@$arr, $spl_num ) #if $header_arr_num => 0      ;
    }
   }
   if ( grep(/\w/, @$arr) ) { 
     push( @{$self -> {out_stack}}, $arr) }               ;
   }
}

sub single_search {

  my $self = shift                                            ;
  my $srch_arr                                                ;
  @$srch_arr = @_                                             ;
  my $struct = $self -> {assc_arr}                            ;
  $self -> search_descend($struct)                            ;
   
  $single_search_str = $self -> { 'single_search_str' }       ;
  $single_search_str =~ s/([\+\?\.\*\$\(\)\[\]\\])/\\$1/g     ;
 
  
  @single_search_arr = split(/\n/, $single_search_str )       ;
  
  foreach $single_search_line ( @single_search_arr ) {
  chop $single_search_line ;


  @$and_arr = split(/\&/, $single_search_line )                ;

  $self -> {'regex_struct'} = []                              ;
  foreach $and_srch_str (@$and_arr) {
    my $or_arr                                                ;
    @$or_arr =  split(/\|/, $and_srch_str )                   ;
    push ( @{$self -> {'regex_struct'}}, \@$or_arr )
  }

  ARR :
  foreach $arr (@{$self -> {srch_arr_stack}}){ ### get array off stack
    my $cnt                                                   ;
    foreach $cell (@$arr) {
      if ( ref $cell eq 'ARRAY' ) {
        $cell = join('<BR>', @$cell)                          ;
        $$arr[$cnt] = $cell                                   ;
      }       
      $cnt ++
    }
    my $flag = 'no'                                           ;
    AND :
    foreach $and ( @{$self -> {'regex_struct'}} ) {
     foreach $or ( @$and ) {
      $flag = 'no'                                            ;
      $or =~ s/(^ *| *$)//g                                   ;
      if ( grep (/$or/, @$arr ) ) {
       $flag = 'yes'                                          ; 
       next AND  
      }
      $flag = 'no'                                            ;
     }
     next ARR if $flag eq 'no'
    }
    push(@{$self-> {arr_stack}}, $arr)                        ;
  }

  }
  print $self -> generate_table
  
}

sub search {
    my $self = shift                                         ;
    my $srch_arr                                             ;
    @$srch_arr = @_                                          ;  
    my $struct = $self -> {assc_arr}                         ; 
    $self -> search_descend($struct)                         ;
    NEW_ARR :
    foreach $arr (@{$self -> {srch_arr_stack}}){ ### get array off stack
       @$out_arr = @$arr                                     ;
       my $cnt                                               ;
       foreach $regexp (@$srch_arr) {  ### foreach regexp string
         my $str = shift @$arr                ; ### shift array
         $ref_thing = ref $str                ; 
         if ( ref $str ne 'ARRAY' ) {  
           if ( $str !~ /$regexp/i ) { 
             next NEW_ARR if $regexp ne ''    ;          
           }         
         }
         else { 
           if ( ! grep(/$regexp/i, @$str ) ) {
             next NEW_ARR if $regexp ne ''
           }
           my $str =  join ( "<BR>", @$str )                    ;
           $$out_arr[$#$out_arr] = $str                         ;
         }
      }    
      $in = $self -> dump($out_arr)                             ;
      $in = eval $in ;
      my $cnt ; 
      foreach $cell (@$in) {
        $cell = join ( "<BR>", @$cell ) if ref $cell eq 'ARRAY' ; 
        $$in[$cnt] = $cell ;
        $cnt++
      }
     push(@{$self-> {arr_stack}}, $in)                          ;
    } 
    if ( $self-> {tmp_arr_stack} ) {
     $self -> fmt                                               ;
     foreach $arr ( @{$self-> {tmp_arr_stack}} ) {
      my $cnt                                                   ;
      foreach $cell (@$arr) {
        $cell = join ( "<BR>", @$cell ) if ref $cell eq 'ARRAY' ;
        $$arr[$cnt] = $cell                                     ;
        $cnt++
      }
      push(@{$self-> {arr_stack}}, $arr)                        ;
     }
    }
    print $self -> generate_table
}

sub search_descend {
  my $self = shift                                           ;
  my $struct = shift                                         ;
  foreach $key ( sort keys %{$struct} ) 
    { $ref_thing = ref $struct -> {$key}                     ;
    if ( $ref_thing =~ /HASH/ ) {
      push(@{$self -> {srch_tmparr}}, $key)                  ;
      $self -> search_descend($struct -> {$key})             ;
    }
    else {
     my @srch_arr = @{$self -> {srch_tmparr}}                ;
     push(@srch_arr, $key)                                   ;
     push(@srch_arr, $struct -> {$key})                      ;
     push(@{$self -> {srch_arr_stack}}, \@srch_arr);
    }
  }
      pop(@{$self -> {srch_tmparr}})                         ;
} 

sub DESTROY {
    my $self = shift                                         ;
    $self -> send_recv('exit')                               ;
}

1;
