package CXN::JavaScript;

sub new {
    my $self = {}                                        ;
    my $class = shift                                    ;
    bless ($self, $class)                                ;
    return ( $self )
}


sub js_ob_upd_popup  {
  my $self = shift                                              ;
  my $struct = shift                                            ;

  my $out=<<END;
<script language="JavaScript">

<!--
function UPD_OB(db, depth_str, val_str) {
 var upd;
 var nm = '';
 upd = window.open(nm, "update_object", 'resizable=yes,scrollbars=no,status=0,width=250,height=330');
 upd.document.writeln('<head><title>Depth UPD_OB</title></head>');
 upd.document.writeln('<body bgcolor="lightblue" onload="if (window.focus!=null) { window.focus();}">');
 upd.document.writeln("<H3><font color=darkblue>DB:</font> "+db+"<H3><font color=darkblue>Depth String:</font> "+depth_str+"<H4>");
 upd.document.writeln("<DIV align=center><FORM METHOD=\\"POST\\" ACTION=\\"/cgi-bin/depth/upd\\"\\
                      ENCTYPE=\\"application/x-www-form-urlencoded\\" TARGET=\\"depth_canvas\\">\\
                      <textarea NAME=\\"upd "+db+" "+depth_str+"\\" COLS=20 ROWS=\\"1\\" >" +val_str+ "</textarea>\\
                      <BR>New_Object<input TYPE=\\"radio\\" VALUE=\\"new_last_ob\\" NAME=\\"upd_chkbx\\" checked >\\
                      <BR>Extend_Object<input TYPE=\\"radio\\" VALUE=\\"new_ext_last_ob\\" NAME=\\"upd_chkbx\\">\\
	 <BR><INPUT TYPE=\\"image\\" src=\\"/images/update_object.gif\\" border=0 VALUE=\\"Update\\"></FORM>");
 upd.document.writeln("<HR><FORM METHOD=\\"POST\\" ACTION=\\"/cgi-bin/depth/del\\" \\
                      ENCTYPE=\\"application/x-www-form-urlencoded\\" TARGET=\\"depth_canvas\\"><BR>\\
                      <INPUT TYPE=\\"image\\" SRC=\\"/images/delete_object.gif\\" border=0 NAME=\\"del "+db+" "+depth_str+"\\">\\
                      </FORM></DIV>");

 upd.document.writeln('</body>');

 upd.document.close();
}
// -->
</script>
END
return $out
}

sub DESTROY {
    my $self = shift                                            ;
}

1;
