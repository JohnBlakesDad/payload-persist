#!/usr/bin/perl

use strict ;

my @arr_ls ;

@arr_ls = ( 'john', 'mary', 'job', 'etc' ) ;

my $arr ;

foreach $arr (@arr_ls) { push (@$arr, '$arr') }

exit ;


$a -> [0] = 'a'  ;

$b -> [0] = 'b'  ;

my ($arr_ref, $ref) ;

foreach $ref ('a', 'b' ) { 
  $arr_ref = \$ref ;
  push ( @${arr_ref}, "xx")
}

print "\n"       ;

my $hash         ;

$hash -> {'key1'} = 'val 1 ' ;
$hash -> {'key2'} = 'val 2 ' ;

my ( @arr, @val );

@arr =  keys   %{$hash} ;
@val =  values %{$hash} ;

print join (' ', @arr),"\n" ;

print join (' ', @val),"\n" ;


