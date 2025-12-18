package LocalDepth;

use URI::Escape ;
use DeepDB ;

sub new {
    my $self = {}                                        ;
    my $class = shift                                    ;
    $self -> {db_name} = shift                           ;
    $self -> {DB} = new DeepDB                           ;      
    $self -> {DB} -> db($type) if $type  = shift         ;      
    bless ($self, $class)                                ;
    return ( $self )
}

sub db {
    my $self = shift                                     ;
    $type = shift                                        ;
    return $self -> {DB} -> db( $type )                  ;  
}         

sub layer {
    my $self = shift                                     ;
    return $self -> {DB} -> layer(@_)                    ;
}

sub depth {
    my $self = shift                                     ;
    return $self -> {DB} -> depth(@_)                    ;
}

sub upd {
    my $self = shift                                     ;
    return $self -> {DB} -> upd(@_)                      ;
}

sub del {
    my $self = shift                                     ;
    return $self -> {DB} -> del(@_)                      ;
}

sub write {
    my $self = shift                                     ;
    return $self -> {DB} -> write                        ;
}

sub pretty_print {
    my $self = shift                                      ;
    my $val                                               ;
    if ( $val = shift ) { $self -> {pretty_print} = $val }  
    else { $self -> {pretty_print} = 'yes' }
    return $val 
}

sub serialize {
    my $self = shift                                      ;
    my $thing = shift ;
    #my $thing = $self -> {"$thing"}                      ;
    use Data::Dumper                                      ;
    my $dump_str1 = Data::Dumper->new([$thing])           ;
    $dump_str1 ->Indent(0) if $self -> {pretty_print} ne 'yes'     ;
    $dump_str1 ->Names([$self -> {dump_name}])
                        if $self -> {dump_name} ne ''     ;
    my $ret                                               ;
    $ret = $dump_str1->Dumpxs                             ;
    return $ret
}

sub prep {
   my $self = shift            ; 
   my $str = shift             ;
   $str = $self -> dump($str)  ;
   $str =~ s/,/\\,/g           ;
   $str =~ s/\'/\\'/g          ;
   return $str
}

sub DESTROY {
    my $self = shift                                            ;
}

1;
