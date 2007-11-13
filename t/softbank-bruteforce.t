use strict;
use warnings;
use Test::More;

use Encode;
use Encode::JP::Mobile;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/softbank-table.yaml");

plan tests => 2 * @$dat;

for my $r (@$dat) {
    my $sjis = pack "H*", $r->{sjis};
    my $unicode = chr hex $r->{unicode};
    is decode("x-sjis-softbank", $sjis), $unicode, $r->{unicode};
    is encode("x-sjis-softbank", $unicode), $sjis, $r->{unicode};
}
