#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Path::Class;
use YAML;

unless (@ARGV==2) {
    die <<"...";
Usage: $0 primary-encode secondary-encode
    i.e. $0 unicode unicode_auto > ucm/x-sjis-kddi-cp932-raw.ucm
      or $0 unicode_auto unicode > ucm/x-sjis-kddi-auto-raw.ucm
...
}

&main;exit;

sub main {
    my ($primary, $secondary) = @ARGV;

    my $cp932 = file($FindBin::Bin, '..', 'ucm', 'cp932.ucm')->openr;
    print header($primary);
    while (<$cp932>) {
        next if /^#/;
        next if /<code_set_name> "cp932"/;
        next if /PRIVATE USE AREA/;
        next if /END CHARMAP/;
        print $_;
    }
    print "# below are copied from KDDI/AU's pictogram map\n";
    for my $row (kddi_table($primary)) {
        printf "<U%s> %s |0 # KDDI/AU Pictogram\n", $row->{$primary}, hexify($row->{sjis});
    }
    print footer();
}

sub kddi_table {
    my $sort_key = shift;

    sort { hex( $a->{$sort_key} ) <=> hex( $b->{$sort_key} ) }
      @{ YAML::LoadFile( file( $FindBin::Bin, '..', 'dat', 'kddi-table.yaml' ) )
      };
}

sub hexify {
    local $_ = shift;
    s/(..)/\\x$1/g;
    $_;
}

sub header {
    my $primary = shift;
    my ($e1, $e2);
    if ($primary eq 'unicode_auto') {
        ($e1, $e2) = ('x-sjis-kddi-auto-raw', 'x-sjis-ezweb-auto-raw');
    } else {
        ($e1, $e2) = ('x-sjis-kddi-cp932-raw', 'x-sjis-ezweb-cp932-raw');
    }

    return <<"...";
<code_set_name> "$e1"
<code_set_alias> "$e2"
...
}

sub footer {
    return <<'...';
END CHARMAP
...
}
