package Args ; 

=pod

=head1 NAME

Gargs.pm - A simplified module to correctly set command line options.

=head1 USAGE

my ($a, $b) ;
use Args; $args = new Args ; $args -> args ; 
$args -> set_defaults( 'a'=>1,'b'=>2,...) ;
$args -> set_opts ;


=over 5 

#It takes the following: cmd -a x -b y z and sets where $opt_a equals 'x' and $opt_b equals 'y z'.   In cmd x -a z y $opt_def would equal 'x' and $opt_a would equal 'y z' .

=head1 DESCRIPTION

It takes the following: cmd -a x -b y z and sets where $opt_a equals 'x' and $opt_b equals 'y z'.   In cmd x -a z y $opt_def would equal 'x' and $opt_a would equal 'y z' .

=head1 BUGS

When using strict, the $opt_whatever has to be given scope with the 'my' funcition.  In casual scripting, that can be ignored.  Perl 5.6 uses the 'our' function to create scope upwards.  This will be implemented asap.

=back

=cut

#use strict;

sub new {
  my $class = shift ;
  my $self = {};
  bless ($self , $class );
}

sub args {

   my $self = shift ;
   my $opt='def' ;

   my $arg ;

  if ( $#ARGV > -1 ) { 
     foreach $arg ( @ARGV ) {
       if ( $arg !~ /^-(\S*)/ ) { 
         push ( @{$self -> {'opt_data'}{$opt}}, $arg ) ;
       }
#       else { $opt=$1 ; $self -> {'opt_data'}{$opt} = [] };
       else { $opt=$1 ; $self -> {'opt_data'}{$opt} = undef };
   }
  } 
}

sub set_defaults {

   my $self = shift ;
   my %defaults = @_                                         ;
   my @def_keys = keys %defaults                             ;
   my $def_key                                               ;
   foreach $def_key (@def_keys) {
     my $def_def = $defaults{ $def_key }                     ;
     if ( ! defined $self -> {'opt_data'}{$def_key} ) { 
       @{$self -> {'opt_data'}{ $def_key }} 
                           = split ( /\s+/, $defaults{ $def_key } )  
     }
     else { $self -> {'opt_data'}{ $def_key } = [] }
   }
}

sub set_args {
   my $self = shift ;
   my ( $key, $str ) ;

   foreach $key ( keys %{$self -> {'opt_data'}} ) {
      $str .= " \$$key=\"" ;
      if ( $#{$self -> {'opt_data'}{$key}} > -1 ) {
        foreach ( @{$self -> {'opt_data'}{$key}} ) { 
          $str .= "$_ " 
        }
        chop $str ;
      }
      else { $str .= 'yes' }
      $str .= '"; '
   }
  return $str
}

 
sub set_shell_args {
   my $self = shift ;


   my ( $key, $str )  ;
   foreach $key ( keys %{$self -> {'opt_data'}} )
     { 
     $str .= "$key=\"" ;
     if ( $#{$self -> {'opt_data'}{$key}} > -1 ) {
       foreach ( @{$self -> {'opt_data'}{$key}} ) { 
         $str .= "$_ "  
       } 
       chop $str ;
      }
      else { $str .= 'yes' }
      $str .= '"; ' 
     }  
  print $str ;
  return ;
}

1;
