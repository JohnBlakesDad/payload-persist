package Super ;

use Sub   ;

my $test = "test yes" ;

sub new {
    my $class = shift ;
    my $self = {} ;
    $self -> {'Sub'} = new Sub($self) ;
    bless ( $self , $class ) ;
    $self -> {'dodo'} = 'crap';
    return $self  
}

sub doit {
  my $self = shift ;
  return $self -> {'Sub'} -> doit ;
}

sub test_sub {
  my $self = shift ;
  print "\n in super \n"  
}

sub doneit {
  my $self = shift ;
  return 'hello'
}



1;
