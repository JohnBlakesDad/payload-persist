package CXN ;

=pod

=head1 NAME

CXN.pm - Client Module ( Server section coming soon )

=head1 USAGE

use CXN ; 
$net_ob -> new CXN( <client or server>, <host name>, <port>, <tcpip or udpip> ) ;
$net_ob -> cxn ;
 
In a script:
client.prl [ -mode client -host <hostname> -port <port num> -proto <tcpip or udpip> ]
host defaults to localhost and proto to tcpip

=head1 DESCRIPTION

This is called by client.prl which this module to carry on a conversation with conversation with serverd.prl.  

=head1 BUGS

The server aspect is still under construction.
The DESTROY method has to be called explicitly in the script.

=cut

use IO::Socket ;

sub new {

=pod

=head1 METHODS

=head2 new

This method constructs the object.
$net_ob -> new CXN( <client or server>, <host name>, <port>, <tcpip or udpip> ) ;

=cut


    my $class = shift                                     ;    
    my $self = {}                                         ;
    my @args = @_                                         ;
    my @keys = ( 'mode', 'host', 'port', 'proto' )        ;
    my @defs = ( 'client', 'localhost', '6666', 'tcpip' ) ;
    my $key                                               ;
    foreach $key (@keys) {
      my $def = shift @defs                               ;
      my $arg = shift @args                               ;
      if ( defined $arg ) { $self -> { $key } = $arg }
      else                { $self -> { $key } = $def }    ;
    }
    bless ($self, $class)                                 ;
    return ( $self )
}

sub cxn { 

=pod

=head2 cxn 

This method connects to the server using the IO::Socket module

$netob -> cxn ;

=cut

    my $self = shift ;
    if ( $self -> {'mode'} eq 'client' ) {
       $self -> {handle} -> autoflush(1) if 
       $self -> {handle} = IO::Socket::INET -> new(
                                   PeerAddr => $self -> {'host'},
                                   PeerPort => $self -> {'port'},
                                   Proto => $self -> {'proto'},
                                  ) or warn "Can't cxn" ;
       $self -> {handle} -> autoflush(1) 
    }
    else {
       die "Client only, the server section coming soon"
       }
    }
} 

sub send { 

=pod

=head2 send

This method sends a string to the client 

$netob -> send('string') ;

=cut

    my $self = shift                           ;
    my $send = shift                           ;
    chomp $send                                ;
    $send .= "\n"                              ;
    $self -> {handle} -> send($send)           ;
    $self -> {handle} ->autoflush(1)           ;
}

sub recv {

=pod

=head2 recv

This method receives data from the server.  It is designed to buffer very long lines of data,  The maximum it can receive is 16K in a single packet and uses the _until_ loop to continue reading from the socket until a terminator is received, in this case the newline.

$string = $netob -> recv ;

=cut

    my $self = shift                           ;
    my $line                                   ;
    my @buff                                   ;
    $self -> {handle} -> recv($line,16384, 0)  ;
    push(@buff, $line)                         ;
    until ( $line =~ /\n$/ ) {
     $self -> {handle} -> recv($line,16384, 0) ;
     $line =~ /^$/ && last                     ;
     push(@buff, $line)                        ;
    }
    $line = join('', @buff)                    ;
    chomp $line                                ;
    return $line
}

sub msg {

=pod

=head2 msg

The msg method is a combination of the send and recv methods

$in_string = $netob -> msg('out_string') ;

=cut
 
    my $self = shift                           ;
    my $send = shift                           ;
    $self -> send($send)                       ;
    $line = $self -> recv                      ;
    return $line 
}
    
sub DESTROY {

=pod

=head2 DESTROY

This _has_ to be called explicitly

=cut

    # Note: this may need to be called explicitly
    my $self = shift                           ;
    return $self -> msg('goodbye')
}

1;

