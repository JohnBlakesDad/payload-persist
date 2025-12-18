package CXN::FreezeDB ;

use Storable;
use Data::Dumper;

sub new {
    my $self = {}                        ;
    my $class = shift                    ;
    $self -> {base_dir}     =  "/opt/adm/db/"  ;
    #$self -> {base_dir}     =  "/adm/db/"  ;
    if (( my $type = shift ) and ( $type ne '' )) { 
    $self -> set_db($type) } ; 
    $self -> {struct}       = undef      ;
    $self -> {struct_tag}   = undef      ;
    $self -> {write}   = undef           ;
    bless ($self , $class)               ; 
    return ( $self ) 
}

sub set_db {
    my $self = shift                     ;
    my $type = shift                     ;
    if ( $type ne '') {
     $self -> {db_type} =  $type         ;
     $self -> {db_dir} = $self -> {base_dir}.$self -> {db_type}.'/' ;
     if ( -d $self -> {db_dir} ) { $self -> {db_set} = 'yes' }
     else { $self -> {db_set} = 'no' }
     return $self -> {db_set}.": ".$self -> {db_type} ;
    }
}

sub write { 
    my $self = shift ; 
    #print $self -> {db_set},"\n" ;
    #if ( $self -> {db_set} eq 'yes' ) {
    #if ( $self -> {db_set} ) {
    # $self -> {write} = 'yes'  }
    #else { die "db not set" }
     $self -> {write} = 'yes'  
}

sub no_write { my $self = shift ; $self -> {write} = 'no'  }

sub struct {
    my $self = shift                       ;
    my $struct_tag = shift ;
    if (( defined $struct_tag ) 
                and ( $self -> {struct_tag} ne $struct_tag )) { 
     if ( $self -> {struct_tag} ne '' ) 
      { $self -> sync if $self -> {write} eq 'yes' } 
     $self -> load($struct_tag) 
    }
    $self -> {struct_tag} = $struct_tag                  ;   
    return $self -> {struct_tag}
}

sub load { 
    my $self = shift                                     ;
    my $freeze_file = shift                              ;
    $freeze_file = $self -> {db_dir}.$freeze_file.'.fz'     ;
    if ( -f $freeze_file ) {
     $self -> {struct} = retrieve($freeze_file)          ;
     $self -> {struct_tag} = $freeze_file                ;
    }
    else { $self -> {struct} = {} }
}

sub sync {
    print "<BR>sync<BR>" if $self -> {debug}             ;
    my $self = shift                                     ;
    my $freeze_file = $self -> {struct_tag}              ;
    my $ff_base_name = $self -> {struct_tag}             ;
    #my $freeze_file_name = $self -> {db_dir}.$freeze_file.'.fz' ; 
    $freeze_file = $self -> {db_dir}.$freeze_file.'.fz' ; 
    #print "<br>".$freeze_file." free <br> ";
    $self -> dump                                        ;
    my $store_arr = $self -> {struct}                    ;     
    if ( $self -> {write} eq 'yes' ) {
       my $dirname = $self -> {db_dir}                      ;
       $dirname =~ s/^(.*)\/[^\/]+$/$1/                     ;
       if ( ! -d $dirname ) { 
        #print "Making: $dirname\n"                          ;
        `mkdir -p $dirname` 
       }                                                    ;
       #print " fff $freeze_file ile \n" ;
       my $freeze_file_tmp = "/tmp/$ff_base_name.$$.tmp"          ;
       store( \%$store_arr, $freeze_file_tmp ) ;
       rename( $freeze_file_tmp , $freeze_file ) 
              || warn "rename failed: $freeze_file_tmp , $freeze_file" ;
    }
    else { print "Set write failed<BR>" } ;
}

sub dump {
    my $self  = shift                                    ;
    my $ref = $self -> {struct}                          ; 
    $dump_str = Data::Dumper->new([$ref])                ;
    $dump_str->Indent(0) if $self -> {indent} ne 'yes'   ;
    my $ret = $dump_str->Dumpxs                          ;
    $dump_str1 = ''                                      ;
    return $ret
}

sub old_ls_files {
    my $self = shift                                     ;
    my $dir = $self -> {base_dir}."/".$self -> {db_type} ;
    $file_ls = `cd $dir ; ls *.fz`    ;
    chomp $file_ls                                       ;
    $file_ls =~ s/\.fz//g                                ;
    $file_ls =~ s/\.\///g                                ;
    @file_ls = split ("\n", $file_ls )                   ;
#    shift @file_ls                                       ; 
    return @file_ls
}

sub ls_files {
    my $self = shift                                     ;
    my $dir = $self -> {base_dir}."/".$self -> {db_type} ;
    opendir DIR , $dir                                   ;
    my @tmp_files = readdir DIR                          ;
    my ( $file, $files )                                 ;
    foreach $file (@tmp_files) 
       {  $file =~ /(.*.)\.fz$/ && push @$files, $1  }
    return @$files
}

sub ls_dirs {
    my $self = shift                                     ;
    my $dir = $self -> {base_dir}                        ;
    opendir ( DIR, $dir )|| warn "no $dir"               ;
    my $dirs                                             ;
    @$dirs = readdir DIR                                 ;
    shift @$dirs ;  shift @$dirs                         ;
    return @$dirs                                        ;
}

1;

