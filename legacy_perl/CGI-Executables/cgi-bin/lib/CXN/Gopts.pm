package Gopts ; 

sub gopts {

my $arrnum   ; 
my $a        ;
my $b        ;
my %rules    ;
my @flags    ;
my @args     ;
my $flag     ;
my $x        ;
my $flagstr  ;
my %flagarr  ;

$arrnum = @_ ;

foreach (<@ARGV>) {
    if ( $_ =~ /^-(\S*)/) { if ( $flag ) { $flagstr =~ s/^ // ;
                                          $flagarr{"opt_".$flag} = $flagstr ;
                                        }
                           $flag = $1        ;
                           $flagstr = ""     ;
                         }
    else { $flagstr = $flagstr." ".$_ }
$flagstr =~ s/^ // ;
$flagarr{"opt_".$flag} = $flagstr ;
if ( exists $flagarr{"opt_"} ) { $flagarr{"opt_def"} = $flagarr{"opt_"};
                             delete $flagarr{"opt_"} }

                  }
return %flagarr;
}

sub set_opts {
%opts = Gopts::gopts(eval $ENV{opts_rules}) ;
#%opts = Gopts::gopts ;
foreach $key ( keys %opts ) {
$str="\$$key=\"$opts{$key}\""                   ;
if (  $opts{$key} eq "" ) { $str="\$$key=\"yes\"" } ; 
$out_str = $str." ; ".$out_str                ;
             }
$out_str = $out_str ;

return $out_str;
}

sub set_shell_opts {
%opts = Gopts::gopts(eval $ENV{opts_rules}) ;
foreach $key ( keys %opts ) {
$str="$key=\"$opts{$key}\""                   ;
if (  $opts{$key} eq "" ) { $str="$key=\"yes\"" } ;
$out_str = $str." ; ".$out_str                ;
             }
$out_str = $out_str ;
return $out_str;
}

1;
