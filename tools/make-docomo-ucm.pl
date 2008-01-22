#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Path::Class;
use YAML;

&main;exit;

sub main {
    my $cp932 = file($FindBin::Bin, '..', 'ucm', 'cp932.ucm')->openr;

    print header();
    while (<$cp932>) {
        next if /^#/;
        next if /<code_set_name> "cp932"/;
        next if /PRIVATE USE AREA/;
        next if /END CHARMAP/;
        print $_;
    }
    print "# below are copied from DoCoMo's pictogram map\n";
    for my $row (docomo_table('unicode')) {
        printf "<U%s> %s |0 # DoCoMo Pictogram\n", $row->{'unicode'}, hexify($row->{sjis});
    }
    print footer();
}

sub docomo_table {
    my $sort_key = shift;

    sort { hex( $a->{$sort_key} ) <=> hex( $b->{$sort_key} ) }
      @{ YAML::LoadFile( file( $FindBin::Bin, '..', 'dat', 'docomo-table.yaml' ) )
      };
}

sub hexify {
    local $_ = shift;
    s/(..)/\\x$1/g;
    $_;
}

sub header {
    return <<"...";
<code_set_name> "x-sjis-docomo-raw"
<code_set_alias> "x-sjis-imode-raw"
...
}

sub footer {
    return <<'...';
END CHARMAP
...
}

