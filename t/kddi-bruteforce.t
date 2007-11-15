use strict;
use warnings;
use Encode;
use Encode::JP::Mobile ':props';

use Test::More;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/kddi-table.yaml");
plan tests => 10 * @$dat;

for my $r (@$dat) {
    my $sjis = pack "H*", $r->{sjis};
    my $jis  = "\e\$B" . pack("H*", $r->{email_jis}) . "\e(B";

    my $unicode = chr hex $r->{unicode};
    is decode("x-sjis-kddi", $sjis), $unicode, $r->{unicode};
    is encode("x-sjis-kddi", $unicode), $sjis, $r->{unicode};
    is encode("x-sjis-kddi-auto", $unicode), $sjis, $r->{unicode};
    is decode("x-iso-2022-jp-kddi", $jis), $unicode, $r->{unicode};
    is encode("x-iso-2022-jp-kddi", $unicode), $jis, $r->{unicode};

    # decode x-sjis-kddi to Unicode, then encode using x-sjis-kddi-auto
    my $copy = $sjis;
    Encode::from_to($copy, "x-sjis-kddi", "x-sjis-kddi-auto");
    is $copy, $sjis, "x-sjis-kddi to x-sjis-kddi-auto roundtrip $r->{unicode}";
    Encode::from_to($copy, "x-sjis-kddi-auto", "x-sjis-kddi");
    is $copy, $sjis, "x-sjis-kddi-auto to x-sjis-kddi roundtrip $r->{unicode}";

    ok $unicode =~ /^\p{InKDDIPictograms}+$/;
    ok $unicode =~ /^\p{InMobileJPPictograms}+$/;
    ok $unicode !~ /^\p{InDoCoMoPictograms}+$/;
}
