package CXN::top ;

use CXN::bottom ;

my $bottom = new CXN::bottom ;

sub new {
    my $class = shift                                    ;
    my $self = {}                                        ;
    bless ($self, $class)                                ;
    return ( $self )
}

sub bottom {
 return $bottom
}

