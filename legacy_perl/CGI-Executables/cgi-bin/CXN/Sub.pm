package Sub ;

use Super ;
@ISA = qw( Super ) ;
 

sub new {
  my $class = shift ;
  my $self = {}; 
  bless ( $self , $class ) ;
  $self -> {'caller'} = shift ; 
  return $self 
}

sub doit {
   my $self = shift                        ;
   use Data::Dumper                        ;
   #my $caller = caller()                   ;
   #print $caller," caller\n"               ;
   #print $${caller}::test."  test\n"      ;
   use Super ;
   print Super::test."  test\n"         ;
   #$Data::Dumper::Indent = 2              ;
   #print Dumper( $self )                  ;
   #print $self -> SUPER::test_sub         ;
   #print $SUPER::test                     ;
   return $self -> {'caller'} -> {'dodo'}  ;
}

sub doit2 {
   my $self = shift ;
   return "xxx"
}

1;
