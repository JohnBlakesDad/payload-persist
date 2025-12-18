#!/bin/sh

raw_free_indexes="
swoix
swanx
swpix
"

free_indexes=`for i in $raw_free_indexes
do
echo $i
done | sort `

echo "<!doctype html public \"-//w3c//dtd html 4.0 transitional//en\">


<html>
<head>
   <meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">
   <meta name=\"Author\" content=\"John van Vlaanderen\">
   <meta name=\"GENERATOR\" content=\"Mozilla/4.7 [en]C-CCK-MCD NSCPCD47  (WinNT; I) [Netscape]\">
   <title>Charts</title>
</head>
<body>
"
echo "<img src=http://a1128.g.akamaitech.net/v/1128/402/1m/akachart.bigcharts.com/custom/schwab_frontpage/schwab-fp-nasdaq-2.img?.3528766829036048>"

for i in $free_indexes
do

echo "<H2><FONT color=red><BR><BR><BR><BR><BR><HR><a target=chart href=http://chart.bigcharts.com/bc3/intchart/frames/chart.asp?symb=SWINX&compidx=SP500%3A3377&comp=DJIA&ma=1&maval=9&uf=8&lf=1&lf2=65536&lf3=1&type=2&size=2&state=13&sid=11078&style=320&time=6&freq=1&nosettings=1&rand=774>  $i</a></font><BR>"
echo "<img src=http://chart.yahoo.com/c/3ms/s/$i.gif>"
echo "<img src=http://chart.yahoo.com/c/3mm/s/$i.gif><BR><BR></H2></font>"

done

echo "</body> </html>"
