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

open ( FS, "free_indexes.ls" )      ;                            

while (<FS>) { 
chomp                               ;
print ;
push (@free_indexes, $_ ) 
}

foreach $idx ( @free_indexes ) {

print<<EOF;

<H2><FONT color=red><BR><BR><BR><BR><BR><HR>
<a target=chart href=http:/chart.bigcharts.com/bc3/intchart/frames/chart.asp?symb=SWINX&compidx=SP500%3A3377&comp=DJIA&ma=1&maval=9&uf=8&lf=1&lf2=65536&lf3=1&type=2&size=2&state=13&sid=11078&style=320&time=6&freq=1&nosettings=1&rand=774>  $i</a></font><BR><img src=http://chart.yahoo.com/c/3ms/s/$i.gif>
<img src=http://chart.yahoo.com/c/3mm/s/$i.gif><BR><BR></H2></font>

EOF

}

print $query->end_html;    
