package Table;
#use  Data::Dumper;

#$main::_INDENT = 0;

sub die_dump {
	my $table = shift;
	my $err = shift;
 	main::fatality("<h1>$err</h1><pre>".Dumper($table)."</pre>");
}

sub new {
	my ($pkg, $hash) = @_;
	$hash = {} unless (ref($hash) eq 'HASH');
	$hash->{type} = 'TABLE';
	bless $hash, $pkg;
	return $hash;
}	
	
sub generate {
	my ($table) = @_;
	my $o = '';
	die_dump($table,"ERR-1") unless ($table->{type} eq 'TABLE');
	my $c = $table->{content};	
	die_dump($table,"ERR-2 ref of content is ".ref($table->{content})) unless (ref($table->{content}) eq 'ARRAY');
	#$o .= qq[\n] . indent() . qq[<table $table->{style}>\n];
	$o .= qq[\n] . indent() . "<table border=5 align=\"center\" bgcolor=\"#FFFF80\" >\n";
	for (@{$table->{content}}) {
		if (ref($_) eq 'ARRAY') {
			$main::_INDENT_++;
			$o .= indent() . qq[<tr>\n];
			for (@{$_}) {
				$main::_INDENT_++;
				if (ref($_) eq  'HASH') {
					my $size =  (ref($_->{size}) eq 'ARRAY') ? qq[colspan=$_->{size}->[0] rowspan=$_->{size}->[1]] : '' ;
					$_->{content} = $_->{content}->generate() if (ref($_->{content})  =~ /^(Form|Table)$/);
					$o .= indent() . qq[<td $_->{style} $size>$_->{content}</td>\n];
				} elsif (ref($_)  =~ /^(Form|Table)$/) {
					$o .= indent() . q[<td>] . ($_->generate()). qq[</td>\n];
				} elsif (ref($_) eq '') {
					$o .= indent() . qq[<td>$_</td>\n];
				} else {
					die_dump($table,'ERR-3');
				}
				$main::_INDENT_--;
			}
			$o .= indent() . qq[</tr>\n];
			$main::_INDENT_--;
		} elsif (ref($_) eq 'HASH') {
			$main::_INDENT_++;
			$o .= indent() . qq[<tr $_->{style}>\n];
			my ($csopen,$csclose,$cs)=();
			foreach $cs (@{$_->{contentstyle}}) {
				my $t = $cs;
				$t =~ s/^(\w+).*$/$1/; # Only want first word 
				$csopen .= qq[<$cs>];	
				$csclose = qq[</$t>] . $csclose;
			}
			for (@{$_->{content}}) {
				$main::_INDENT_++;
				if (ref($_) eq  'HASH') {
					my $size = (ref($_->{size}) eq 'ARRAY') ? qq[colspan=$_->{size}->[0] rowspan=$_->{size}->[1]] : '';
					$_->{content} =$_->{content}->generate() if (ref($_->{content}) =~ /^(Form|Table)$/);
					$o .= indent() . qq[<td $_->{style} $size>${csopen}$_->{content}${csclose}</td>\n];
				} elsif (ref($_)  =~ /^(Form|Table)$/) {
					$o .= indent() . qq[<td>${csopen}] .($_->generate()). qq[${csclose}</td>\n];
				} elsif (ref($_) eq '') {
					$o .= indent() . qq[<td $size>${csopen}$_${csclose}</td>\n];
				} else {
				die_dump($table,'ERR-4');
				}
				$main::_INDENT_--;
			}
			$o .= indent() . qq[</tr>\n];
			$main::_INDENT_--;
		} else {
			die_dump($table,'ERR-5');
		}
	}
	$o .= qq[\n] . indent() . qq[</table>\n];
	return $o;
}
	
sub indent {
	$main::_INDENT_ += shift();
	return qq[\t]x($main::_INDENT_);
}

sub align {
    my ($type, $text , $thing) = @_;
    my $table = new Table;
    $table -> {style} = 'bgcolor="#FFFF80"';

    if ($type =~ m/a/i) {
        if ($type =~ m/b/i) {
            $table->{content}->[0] = $thing;
            $table->{content}->[1] = $text;
        } elsif ($type =~ m/l/i) {
            for ( 0 .. $#{@{$text}} ) {
                push @{$table->{content}->[0]}, ( (shift @{$text}), (shift @{$thing}) );
            }
        } elsif ($type =~ m/r/i) {
            for ( 0 .. $#{@{$text}} ) {
                push @{$table->{content}->[0]}, ( (shift @{$thing}), (shift @{$text}) );
            }
        } else {
            $table->{content}->[0] = $text;
            $table->{content}->[1] = $thing;
        }
    } else {
        if ($type =~ m/l/i) {
            for (0 .. $#{@{$text}}) {
                $table->{content}->[$_] = [ @{$text}[$_], @{$thing}[$_] ];
            }
        } elsif ($type =~ m/t/i) {
            for ( 0 .. $#{@{$text}} ) {
                $table->{content}->[($_*2)] = [  (shift @{$text})  ];
                $table->{content}->[($_*2)+1] = [  (shift @{$thing}) ];
            }
        } elsif ($type =~ m/b/i) {
            for ( 0 .. $#{@{$text}} ) {
                $table->{content}->[($_*2)] = [  (shift @{$thing})  ];
                $table->{content}->[($_*2)+1] = [  (shift @{$text}) ];
            }
        } else {
            for (0 .. $#{@{$text}}) {
                $table->{content}->[$_] = [ @{$thing}[$_], @{$text}[$_] ];
            }
        }
    }
    return $table;
}

1;
