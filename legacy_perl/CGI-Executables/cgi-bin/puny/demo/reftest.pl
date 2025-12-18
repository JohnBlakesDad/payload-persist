#!/perl/bin/perl

use strict ;

my $ob_arr -> [] ;

$ob_arr -> [ a, b, c ]          ;

$cnt = 0 ;

while (<STDIN>) {        
  $in_arr -> [$cnt] = $_ ;
  $cnt ++
}
 
#print join ( '', @$in_arr ) ,"\n";

sub hello {
    $name = shift ;
    print "hello $name !!!\n" ;
    }

use LocalDepth ;
$ob = new LocalDepth ;

$ob -> fmt ;

#ONE
$ob -> {'ref_test'}[0]    = $ob_arr ;

#TWO
@{$ob -> {'ref_test'}[1]} = @$ob_arr ;

$sub = \&hello ;

$sub -> ( me ) ;

$ob -> {'ref_test'}[3] = $sub ;

$sub_ref = $ob -> {'ref_test'}[3] ;

$sub_ref -> ( you ) ;

$ob_ref = $ob -> {'ref_test'}; 

print ref $ob_ref, "  <-- reference\n" ;

print "DUMP   ".$ob -> dump( $ob_ref ),"\n" ;

