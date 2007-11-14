use strict;
use warnings;
use Test::More;

use Encode;
use Encode::JP::Mobile;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/softbank-table.yaml");

plan tests => 3 * @$dat;

for my $r (@$dat) {
    my $sjis = pack "H*", $r->{sjis};
    my $unicode = chr hex $r->{unicode};
    is decode("x-sjis-softbank", $sjis), $unicode, $r->{unicode};
    is encode("x-sjis-softbank", $unicode), $sjis, $r->{unicode};

    # not testing the actual bytes, but just check if it can be
    # encoded and different from cp932
    my $sjis_auto = encode("x-sjis-softbank-auto", $unicode);
    isnt $sjis_auto, encode("cp932", $unicode);
}
