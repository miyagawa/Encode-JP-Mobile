#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Path::Class;
use YAML;
use Encode;
use Encode::JP::Mobile;

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
    print '<U301C> \x81\x60 |1 # WAVE DUSH', "\n"; # ad-hoc solution for  FULLWIDTH TILDE Problem.
    print "# below are copied from AirHPhone's pictogram map\n";
    for my $row (airh_table('unicode')) {
        printf "<U%s> %s |0 # AirHPhone Pictogram\n", $row->{'unicode'}, hexify($row->{sjis});
    }
    print footer();
}

sub airh_table {
    my $sort_key = shift;

    my @ret;
    my $add_to_ret = sub {
        my $x = shift;
        push @ret,
          +{
            unicode => sprintf('%X', $x ),
            sjis    => unpack( 'H*', encode( 'cp932', chr $x ) ),
          };
    };
    my $map = join "", Encode::JP::Mobile::InAirEdgePictograms(), Encode::JP::Mobile::InDoCoMoPictograms();
    for my $line (split /\n/, $map) {
        if ($line =~ /\t/) {
            my ($min, $max) = map { hex $_ } split /\t/, $line;
            my $i = $min;
            while ($i <= $max) {
                $add_to_ret->($i);
                $i++;
            }
        } else {
            $add_to_ret->(hex $line);
        }
    }
    @ret;
}

sub hexify {
    local $_ = shift;
    s/(..)/\\x$1/g;
    $_;
}

sub header {
    return <<"...";
<code_set_name> "x-sjis-airh-raw"
<code_set_alias> "x-sjis-airedge-raw"
...
}

sub footer {
    return <<'...';
END CHARMAP
...
}

