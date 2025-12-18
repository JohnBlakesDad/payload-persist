#!/Perl/bin/perl

use CGI;
use LocalDepth ;
use URI::Escape ;

$query = new CGI;
$ob = new LocalDepth ;

#start printing here
$TITLE="DepthDB";
$script_name = $query->script_name;

$path_info = $query->path_info;

print $query->header;

# if path_info is null then the script is loaded for the first time
# so create the frames

if (( ! $path_info ) or ( $path_info =~ /^\/$/)) {
    &pr_frameset;
&xit
}

###  This should be a css file 
print "<body background=\"/images/crinkpaper.jpg\" >";

# Funnel subs to correct path_info frames

&pick_db                        if  $path_info =~ /^\/ctls$/         ;
&pick_layer                     if  $path_info =~ /^\/layer$/        ;
&depth                          if  $path_info =~ /^\/depth$/        ;
&pr_canvas_gif                  if  $path_info =~ /^\/canvas_gif$/   ;
&upd                            if  $path_info =~ /^\/upd$/          ;
&search                         if  $path_info =~ /^\/search$/          ;
&search_depth                   if  $path_info =~ /^\/search_depth$/          ;
&del                            if  $path_info =~ /^\/del$/          ;


###This destroys the netdepth object and prints html end

&xit;


### subs only below here

### this creates the frameset

sub pr_frameset {
print <<EOF;

<html><head><title>$TITLE</title></head>
   <frameset cols="19,50">
      <frame src="$script_name/ctls"   name="depth_ctls">
      <frame src="$script_name/canvas_gif" name="depth_canvas">
   </frameset>

EOF
}

sub pick_db {
    $arr = $ob -> db()                     ;
    $arr = eval $arr                       ;
    @$arr = sort @$arr                     ;
    print "<H3> DataBases<\H3><HR>"        ;
    print $query->startform(-action=>"$script_name/layer",-TARGET=>"depth_ctls");
    print $query->radio_group( 
                               -name      => 'db_choice',
                               -Values    =>  $arr,
                               -linebreak => 'yes' ,
                               -Defualt   => 'cts'
                              );
    print " ".$query->submit(-name => 'PICK DB') ;
    print $query->endform;
    &xit 
}

sub pick_layer {

    print "<H3>Depth DB<HR></H3>"                     ; 
    print "<H4> Drill Down </H4>"                     ;
    $db_choice = ${$query -> {db_choice}}[0] ;
    if ( $db_choice ne '' ) { ${$query -> {db}}[0] = $db_choice }
    $db = ${$query -> {db}}[0]                        ;
    $layer = ${$query -> {layer}}[0]                  ;
    $depth_str = $query -> param('depth_str')         ; 
    $depth_str = "$depth_str $layer"                  ;
    $depth_str =~ s/^ +//                             ;
    @$depth_arr = split(/ +/, $depth_str)             ;
    $ob -> db($db)                                    ;

    print $layer_arr_str = $ob -> layer(@$depth_arr)  ; 
    $layer_arr = eval $layer_arr_str                 ;
    print join (' ', @$layer_arr ),"join\n" ;
    @$layer_arr = sort @$layer_arr                    ;

    print $query->startform(-action=>"$script_name/layer",-TARGET=>"depth_ctls");
    $query -> param('depth_str', $depth_str )         ;
    print $query->hidden('depth_str')                 ;
    print $query->hidden('db', $db )                  ;
    print $query->radio_group(
                               -name      => 'layer',
                               -Values    =>  $layer_arr,
                               -linebreak => 'yes' ,
                              );
    print " ".$query->submit(-name => 'DRILL DOWN')         ;
    print $query->endform                                   ;
    $out_depth_str = $depth_str." "                         ;
    if ( $out_depth_str !~ /^ *$/ ) {
       $out_depth_str =~ s/ +/-><BR>/g                      ;
       $out_depth_str = "$out_depth_str <BR>"               ;
       print "<HR><H4>Data Structures<\H4>"                 ;
       print $out_depth_str                                 ;
       print $query->startform(-action=>"$script_name/depth",-TARGET=>"depth_canvas");
       print $query->hidden('depth_str')                    ;
       print $query->hidden('db', $db )                     ;
       print "<BR>Password"                                 ;
       print $query -> password_field(-name=>'secret')      ;
       print "<BR>".$query->submit(-name => 'DEPTH')        ;       
       print $query->endform                                ;
       $hidden_struct -> {db} = $db                         ;       
       $hidden_struct -> {depth_arr} = $depth_arr           ; 
       $hidden_struct_str = $ob -> dump($hidden_struct)     ;
       $query -> param('hidden_struct', $hidden_struct_str) ;
       print $query->startform(-action=>"$script_name/search",-TARGET=>"depth_canvas");
       print $query -> hidden('hidden_struct')              ;
       print " ".$query->submit(-name => 'SEARCH')          ;
       print $query->endform                                ; 
    }
    else {
      $out_depth_str = 'Please Drill Down' ;
    }

    &xit
}

sub depth {

      $hidden_struct_str = $query -> param('hidden_struct') ;
      if ( $hidden_struct_str ne '' ) {
        $hidden_struct = eval $hidden_struct_str        ; 
        $db = $hidden_struct  -> {db}                   ;
        @$depth_arr = @{$hidden_struct  -> {depth_arr}} ;
        $depth_str = join(' ', @$depth_arr )            ;
      }
      else { 
        $db = $query->param('db')                       ;
        $depth_str = $query -> param('depth_str')       ;
      }
      @$depth_arr = split (/ +/, $depth_str )           ;
      @{$ob -> {'depth_arr'}} = @$depth_arr             ;
      $depth_arr_len = @$depth_arr                      ;
      $ob -> db($db)                                    ;
      $ob -> {out_depth_str} = $depth_str               ;
      $ob -> {db} = $db                                 ;
      $ob -> {'click_depth'} = 'yes'                    ;
      $out_depth_str = $depth_str                       ;
      $out_depth_str =~ s/ +/-> /g                      ;
      print "<H2>$out_depth_str -></H2><BR>"            ;

      if ($query->param('secret') eq 'password'){ 
         $ob -> {upd} = 'yes'                           ;
      }

      print "</H3>"                                     ;
      $ob -> {url_path} = 
                       $query->url(-absolute=>1, -path_info=>1, -query=>1);
      $arr_str = $ob -> depth(@$depth_arr)              ;
      $tmp_arr = eval $arr_str                          ;
      if ( keys %$tmp_arr == 0 and $#$depth_arr == 0 and $ob -> {upd} == 'yes') 
      { 
      print 
            "<table><td><FORM METHOD=\"POST\" ACTION=\"/cgi-bin/depth/upd\" ENCTYPE=\"application/x-www-form-urlencoded\" TARGET=\"depth_canvas\"><TEXTAREA NAME=\"upd $db $depth_str \" ROWS=\"4\" ></TEXTAREA>
             </td><td>
             <INPUT TYPE=\"submit\" VALUE=\"New top object\" NAME=\"upd_chkbx\" ></FORM>
             </td></table>
" ;
      }

      $ob -> {assc_arr} = $tmp_arr                    ;
      $ob -> set_header(@$depth_arr)                  ;
      print $ob -> mk_table                           ;

#&dump_query ;
&xit
}

sub upd {
   print $query -> param('hidden_struct')                 ;
   $upd_cmd = @{$query -> {'.parameters'}}[0]             ;
   $upd_val = $query -> param($upd_cmd)                   ;

   @$upd_val = split("\n", $upd_val)                      ;
   my @depth_arr = split(/ +/, $upd_cmd)                  ;
   shift @depth_arr                                       ;
   $db = shift @depth_arr                                 ;
   print "<PRE>",$upd_val," </PRE> upd xx val"                ;
 
   if ( @{$query -> {upd_chkbx}}[0] eq 'new_ob' ) 
     { push @depth_arr, $upd_val                          ;
       $upd_val = undef                                   ;
     }

   elsif ( @{$query -> {upd_chkbx}}[0] eq 'new_last_ob' ) 
     { 
       pop @depth_arr                                     ;
       push @depth_arr, $upd_val                          ;
       $upd_val = undef                                   ;
     }

   elsif ( @{$query -> {upd_chkbx}}[0] eq 'new_ext_last_ob' )
     { 
       push @depth_arr, $upd_val                          ;
       $upd_val = undef                                   ;
     }
   elsif ( @{$query -> {upd_chkbx}}[0] eq 'New top object' )
     {
       push @depth_arr, $upd_val                          ;
       $upd_val = undef                                   ;
     }
 

   #$upd_val = $ob -> arr2str(@$upd_val)                   ;
   print "<PRE> $upd_val </PRE>"                          ;
   print $upd_val," xxx upd val pre"                          ;
   @upd_arr = ( @depth_arr, $upd_val )                    ;
   $ob -> db($db)                                         ;
   print join (' ', @upd_arr), "join\n" ;
   $out =  $ob -> upd(@upd_arr)                           ;
   $hidden_struct -> {db} = $db                           ;
   @{$hidden_struct -> {depth_arr}} = @depth_arr          ;       
   $hidden_struct_str = $ob -> dump($hidden_struct)       ;
   $query -> param('hidden_struct', $hidden_struct_str)   ;
   print $query -> hidden('hidden_struct')                ;
   &depth                                                 ;

}

sub del {

   $del_cmd = @{$query -> {'.parameters'}}[0]             ;
   my @depth_arr = split(/ +/, $del_cmd)                  ;
   shift @depth_arr                                       ;
   pop @depth_arr                                         ;
   $db = shift @depth_arr                                 ;
   #print "<PRE>",$del_val,"</PRE> del val"               ;

   #$del_val = $ob -> arr2str(@$del_val)                  ;
   #print "<PRE> $del_val </PRE>"                         ;
   #print $del_val," del val pre"                         ;
   #@upd_arr = ( @depth_arr, $del_val )                   ;
   @del_arr = ( @depth_arr )                    ;
   $ob -> db($db)                                         ;
   $out =  $ob -> del(@del_arr)                           ;
   $hidden_struct -> {db} = $db                           ;
   @{$hidden_struct -> {depth_arr}} = @depth_arr          ;
   $hidden_struct_str = $ob -> dump($hidden_struct)       ;
   $query -> param('hidden_struct', $hidden_struct_str)   ;
   print $query -> hidden('hidden_struct')                ;
   &depth                                                 ;

}



sub search {

print "hello\n" ;
   $hidden_struct_str = $query -> param('hidden_struct')  ;
   $hidden_struct = eval $hidden_struct_str               ;
   $db = $hidden_struct  -> {db}                          ;
   @$depth_arr = @{$hidden_struct  -> {depth_arr}}        ;
   $depth_str = join(' ', @$depth_arr )                   ;
   $pr_depth_str = join('->', @$depth_arr ).'->'          ;
   $ob -> {out_depth_str} = $depth_str                    ;
   $ob -> {db} = $db                                      ;
   $ob -> db($db)                                         ;
   $ob -> set_header(@$depth_arr)                         ;
   $head_arr_num =  $ob -> {header_arr_num}               ;
   $hidden_struct -> {header_arr_num} = $head_arr_num     ;
   $hidden_struct_str = $ob -> dump($hidden_struct)       ;
   $query -> param('hidden_struct', $hidden_struct_str)   ;
   print $query->startform(-action=>"$script_name/search_depth",-TARGET=>"depth_canvas");
   print "<H3>$pr_depth_str</H3>"                         ;
   foreach $num ( 0..$head_arr_num - 1 ) {
     $arr_str =  $query->textfield("arr_str.$num")       ;   
     push @$form_arr, $arr_str                            ;
   }
   push(@{$ob -> {arr_stack}}, $form_arr)                 ;
   print $ob -> mk_table                                  ;
   print " ".$query->submit(-name => 'SEARCH DEPTH' )      ;
   print $query -> hidden('hidden_struct')              ;
   print $query->endform                                  ;

&xit ;
}

sub search_depth {

   $hidden_struct_str = $query -> param('hidden_struct')  ;
   $hidden_struct = eval $hidden_struct_str               ;
   $db = $hidden_struct  -> {db}                          ;
   @$depth_arr = @{$hidden_struct  -> {depth_arr}}        ;
   $depth_str = join(' ', @$depth_arr )                   ;
   $pr_depth_str = join('->', @$depth_arr ).'->'          ;
   print "<H3>$pr_depth_str</H3>"                         ;
   $ob -> {out_depth_str} = $depth_str                    ;
   $arr_num = $hidden_struct -> {header_arr_num}          ;
   foreach $num (0..$arr_num +1 ) {
    push @$search_arr, ${$query ->{"arr_str.$num"}}[0]    ;
   }

   $ob -> db($db)                                         ;
   $assc_str = $ob -> depth(@$depth_arr)                  ; 
   $ob -> {assc_arr} = eval $assc_str                     ;
   $ob -> search(@$search_arr)                            ;

&dump_query ;
&xit ;
}                    


#################################################
### These should be in a module, but...       ###
#################################################

sub dump_query {
    print $query -> path_info  ;
    $script_name = $query->script_name;
    print "<PRE>"              ;
    $ob -> fmt                 ;
    print $ob -> dump($query)  ;
    print "</PRE>"
}

sub pr_canvas_gif {
    print "<table align=center valign=middle >";
    print "<td>
    <img  src=/images/sun_earth.gif height=\"250\" 
                              align=\"absmiddle\" width=\"450\">
     </td></table>";
&xit 
}

sub xit {
&dump_query ;
print $query->end_html;
$ob->DESTROY;
}
