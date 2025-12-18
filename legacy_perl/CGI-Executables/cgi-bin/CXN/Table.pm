package CXN::Table ; 

sub new {
    my $class = shift                     ;
    my $self = {}                         ;
    $self -> {'border'} = 5               ;
    $self -> {'align'} = 'center'         ;
    $self -> {'background_color'} = 'navajowhite' ;
    bless ( $self, $class )               ;
    return $self 
}

sub gen_tables {
  my $self = shift                        ; 
  my @tables = @_ ;
  my $out ;
  my $border = $self -> {'border'}        ;
  my $align =  $self -> {'align'} = 'center' ;
  my $background_color = $self -> {'background_color'} ;
  my $BG ;
  if ( defined $self -> {'background_color'} ) { 
     $BG = "BGCOLOR=$background_color"
  }
  elsif  ( defined $self -> {'background_image'} ) {
     $BG = 'BACKGROUND='.$self -> {'background_image'} 
  }
  else { $BG='BGCOLOR="white"' }
  foreach $table ( @tables ) {
    $out .= "\n<Table BORDER=$border CELLPADDING=7 ALIGN=$align $BG>\n" ;
    foreach $arr (@$table) {
      $out .= qq[<tr>\n] ;
      foreach $cell (@$arr) {
        $out .= qq[<td><h3>$cell</td>\n];
      }
     $out .= "</tr>\n" ;
    }
    $out .= "</Table>\n" ;
  }
return $out ;
}

sub gen_table {
   my $self = shift ;
   $self -> gen_tables ( \@_ ) ;
}

1;


=pod

=head1 This creates tables from arrays of arrays 

=item

The second level of arrays has elements of table cell contact. 



=head2 Example

use Table ;

my @a= qw[ a1 a2 a3 a4] ;

my @b= qw[ b1 b2 b3 b4] ;

my @c= qw[ c1 c2 c3 c4] ;


my @x = ( \@a, \@b, \@c  ) ;

my @y = ( \@a, \@b, \@c  ) ;

my $table = new Table ;

print $table -> gen_tables ( @x, @y ) ;

=cut
