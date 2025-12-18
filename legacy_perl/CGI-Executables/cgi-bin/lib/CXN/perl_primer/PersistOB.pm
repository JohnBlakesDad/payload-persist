package CXN::PersistOB ;

  # Hi again, 
  # Now that I have shown you complex sturtures and persistant objects, there
  # is only one other thing you need to know about: a module package, or ".pm" 
  # Something else I will use is the "pod" or plain-old-document method of 
  # documentation.

=head1  PersistOb.pm 

=over 5

Hi again, 

Now that I have shown you complex sturtures and persistant objects, there is only one other thing you need to know about: a module package, or ".pm".

Something else I will use is the "pod" or plain-old-document method of documentation.  To see the documentation you type "perldoc somemodule.pm".

This package is a perl module which uses the dump structure in the last script as a tool to read structures in and out of text files, simple but I hope it serves some purpose.  There are other ways to use "package" but just lets go with this for the time being.

A perl module has to start w/ the line at the top where the package name is the file name minus the ".pm".  Since this package uses another module, LocalDepth.pm, the first thing I am going to do is call it in using "use".  Then I am going to call in the strict module.  This prevents programmers from using "casual" syntax and makes the code fit a standard designed to allow perl modules to scale.

The functions (subs) in modules are called methods (no surprise, I hope since this is OO programming) and you need at least one called "new".

I hope this is easy for you to follow.

=cut

use Data::Dumper ;
use strict ;
#my $depth_ob = new LocalDepth ; # creates a depth object for dump

sub new {
    my $self = {} ;    # these lines initalize the class structure
    my $class = shift ;
         # creates a depth object within the global object
         # turns on formatting 
    bless ($self, $class);  
    $self -> pretty_print ;
         # after the new object is blessed, methods can be accessed
    return ($self);
    }

sub load_struct {
    my $self = shift ;
          # this identifies the sub as a method of the class
    my $file = shift ; # same as shift @_ 
    open  (PERSIST_OB_SLURP, "$file" ) || die "Cant open: $file" ;
    my @tmp_in_arr ;
    while (<PERSIST_OB_SLURP>) { push @tmp_in_arr, $_ } ;
    close PERSIST_OB_SLURP ;
    my ( $input_string , $input_struct ) ;
    $input_string = join ( '', @tmp_in_arr ) ;
    my $VAR1 ;
    $input_struct = eval $input_string ;
    return $input_struct ;
}
    
sub store_struct {
    my $self = shift ;
    my $file = shift ; 
    my $struct_ref = shift ; 
    my $out_str = $self -> serialize($struct_ref) ;
#    my $store_arg = shift  ;
#    if ( $store_arg =~ /bin/ or $self -> {binary} eq 'yes' ) { 
#       use Storable ; store ( \$struct_ref , $file )
#       }
#    else { 
      my $out_str = $self -> serialize($struct_ref) ;
      open (PERSIST_OB_STOR, ">$file" ) || die "Cant open: $file" ;
#         }
    print PERSIST_OB_STOR $out_str ;
    close PERSIST_OB_STOR ;
}

sub serialize {
    my $self  = shift ;
    my $ref = shift;
    if ( $ref ne '' ) { $self -> {depth} = $ref }  ;
    my $dump_str ;
    $dump_str = Data::Dumper->new([$self -> {depth}]);
    $dump_str->Indent(0) if $self -> {'pretty_print'} ne 'yes';
    my $ret ;
    $ret = $dump_str->Dumpxs ;
    $dump_str = '';
    return $ret ;
}
    
sub pretty_print {
    my $self = shift ;
    $self -> {'pretty_print'} = 'yes' ;
}   

sub DESTROY {
    exit
}
    
1;
