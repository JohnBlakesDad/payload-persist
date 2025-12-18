package Cxn ;

use IO::Socket ;

sub new {
    my $self = {}                  ;
    my $class = shift              ;    
    $self -> {handle} = undef      ;
    $self -> {remote} = 'localhost' ;
    $self -> {port}   = '6666'     ;
    $self -> {proto}  = 'tcp'      ;
    bless ($self, $class)          ;
    return ( $self )           
}

sub connect { 
    my $self = shift ;
    $self -> {handle} = IO::Socket::INET -> new(
                                   PeerAddr => $self -> {remote}         ,
                                   PeerPort => $self -> {port}           ,
                                   Proto => self -> {proto}              ,
                                  ) or warn "Can\'t conn: $host $port"   ;
    $self -> {handle} -> autoflush(1)                                    ;
} 


sub send { 
    my $self = shift                    ;
    my $send = shift                    ;
    chomp $send                         ;
    $send .= "\n"                       ;
    $self -> {handle} -> send($send)    ;
    $self -> {handle} ->autoflush(1)    ;
}

sub recv {
    my $self = shift                    ;
    my $line = shift                    ;
    my $line = '' ;
    my @buff = () ;
    while ( $line !~ /\n$/ ) {
     $self -> {handle} -> recv($line,16384, 0) ;
     #$self -> {handle} -> recv($line,1024, 0) ;
     $line =~ /^$/ && last ;
     push(@buff, $line) ;
    }
    $line = join('', @buff) ;
    chomp $line  ;
    return $line ;
}

sub msg {
    my $self = shift ;
    my $send = shift ;
    $self -> send($send) ;
    $line = $self -> recv ;
    return $line 
}
    
sub DESTROY {
    # Note: this only wrks some of the time
    my $self = shift ;
    $self -> send('exit')     ; 
    ret $self -> recv ;
}

1;

