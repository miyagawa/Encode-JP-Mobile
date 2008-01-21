#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Path::Class;
use YAML;

unless (@ARGV==1) {
    die <<"...";
Usage: $0 encoding
    i.e. $0 cp932 > ucm/x-sjis-kddi-cp932-raw.ucm
      or $0 auto  > ucm/x-sjis-kddi-auto-raw.ucm
...
}

&main;exit;

sub main {
    my $encoding = shift @ARGV;
    die "invalid encoding: $encoding" unless $encoding =~ /^(cp932|auto)$/;

    my $cp932 = file($FindBin::Bin, '..', 'ucm', 'cp932.ucm')->openr;

    print header($encoding);
    while (<$cp932>) {
        next if /^#/;
        next if /<code_set_name> "cp932"/;
        next if /PRIVATE USE AREA/;
        next if /END CHARMAP/;
        print $_;
    }
    print "# below are copied from KDDI/AU's pictogram map\n";
    my $key = $encoding eq 'cp932' ? 'unicode' : 'unicode_auto';
    for my $row (kddi_table($key)) {
        printf "<U%s> %s |0 # KDDI/AU Pictogram\n", $row->{$key}, hexify($row->{sjis});
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
    my $encoding = shift;

    return <<"...";
<code_set_name> "x-sjis-kddi-$encoding-raw"
<code_set_alias> "x-sjis-ezweb-$encoding-raw"
...
}

sub footer {
    return <<'...';
END CHARMAP
...
}
