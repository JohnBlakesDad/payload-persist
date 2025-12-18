package CXN::NetDepth;

use Cxn ;
use Table ;
use Basic;
use URI::Escape ;

sub new {
    my $self = {}                                        ;
    my $class = shift                                    ;
    $self -> {db_name} = shift                           ;
    $self -> {mach} = shift                              ;
    $self -> {cxn} = new Cxn                            ;
    $self -> {cxn} -> connect                           ;
    #change below to suit opt db
    my $db = $self -> {db_name}                          ;
    #$self -> {table_title} = 'yes' ; 
    bless ($self, $class)                                ;
    return ( $self )
}

sub connect {
    my $self = shift                         ;
    $self -> {cxn} = new Cxn                            ;
    $self -> {cxn} -> connect                           ;
}

sub send_recv {
    my $self = shift                         ;
    my $send_str = shift                     ;
    $self -> {cxn} -> send("$send_str")      ;
    return $self -> {cxn} -> recv()          ;
}

sub db {
    my $self = shift                         ;
    $self -> connect                         ;
    if ( my $type = shift ) {
    return $self -> send_recv("db $type")    ;
    }
    else {
    return $self -> send_recv("db")
    } 
}

sub layer {
    my $self = shift                         ;
    my $send_str                             ;
    $send_str = join('\',\'', @_)           ;
    $send_str = "\'".$send_str."\'"          ;
    return $self -> send_recv("layer $send_str"); 
}

sub depth {
    my $self = shift                         ;
    my $send_str                             ;
    $send_str = join('\',\'', @_)           ;
    $send_str = "\'".$send_str."\'"          ;
    return $self -> send_recv("depth $send_str");
}

sub upd {
    my $self = shift                           ;
    my $client                                 ;
    #$client = Authen::Challenge::Basic->new ('Secret' => 'known2us',
    $client = Basic->new ('Secret' => 'known2us',
                                                'Timeout' => 90,
                                                'Sync' => '' 
                                             ) ;
    my $send_str                               ;
    my $last_elem ;
    $last_elem = $_[$#_]                       ;
    
    $send_str = join('\',\'', @_)              ; 
    $send_str = "\'".$send_str."\'"            ;
    $send_str =~ s/\n/<BR>/                    ;
    my $rand_str                               ;
    $rand_str = $self -> send_recv('upd auth') ;
    my $resp                                   ;
    $resp = $client ->Response($rand_str)      ;
    chomp $resp                                ;
    $client = ''                               ;
    return $self -> send_recv("upd $resp $send_str") ;
}

sub del {
    my $self = shift                           ;
    my $client                                 ;
    #$client = Authen::Challenge::Basic->new ('Secret' => 'known2us',
    $client = Basic->new ('Secret' => 'known2us',
                                                'Timeout' => 10,
                                                'Sync' => ''
                                             ) ;
    my $send_str                               ;
    my $last_elem ;
    $last_elem = $_[$#_]                       ;

    $send_str = join('\',\'', @_)              ;
    $send_str = "\'".$send_str."\'"            ;
    $send_str =~ s/\n/<BR>/                    ;
    my $rand_str                               ;
    $rand_str = $self -> send_recv('del auth') ;
    my $resp                                   ;
    $resp = $client ->Response($rand_str)      ;
    chomp $resp                                ;
    $client = ''                               ;
    return $self -> send_recv("del $resp $send_str") ;
}

sub get_assc_arr {
    my $self = shift                       ;
    #$self -> {decend_title} = $_[$#_]      ;
    my $mach = $self -> {mach}             ;
    my $arr_cnt                            ;
    my $string                             ;
    $string = $self -> depth(@_)           ;
    my $assc_arr = eval $string            ;
    $self -> {assc_arr}{$_[$#_]} = $assc_arr        ;
    return $assc_arr 
}

sub prep {
   my $self = shift            ; 
   my $str = shift             ;
   $str = $self -> dump($str)  ;
   $str =~ s/,/\\,/g           ;
   $str =~ s/\'/\\'/g          ;
   return $str
}

sub arr2str {
   my $self = shift            ;
   @$str = @_                  ;
   $str = $self -> dump($str)  ;
   $str =~ s/,/\\,/g           ;
   $str =~ s/\'/\\'/g          ;
   return $str
}

sub DESTROY {
    my $self = shift                                         ;
    $self -> send_recv('exit')                               ;
}

1;
