package CXN::PersistBIN ;

use Storable ; 
use strict ;

=head1  PersistBIN.pm 

=over 5

This module goes a step beyond PersistOB.pm.  Instead of creating a serializing memory structures into a string and writing that to a file, this puts the structres into a file in binary form.  The file can't be read or edited (bad) but the process is faster and has other more advanced benefits.  The code is also more compact.

To use this tool you need a 

=cut

sub new {
    my $self = {} ;    # these lines initalize the class structure
    my $class = shift ;
    bless ($self, $class);  
    return ($self);
    }

sub thaw {
    my $self = shift ;
    my $file = shift ; # same as shift @_ 
    my $struct = retrieve($file)          ;
    return $struct
}
    
sub freeze {
    my $self = shift ;
    my $struct_ref = shift ; 
    my $file = shift ; 
    store ( $struct_ref , $file )
}
    
sub DESTROY {
    exit
}
    
1;
