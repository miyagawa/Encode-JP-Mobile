use strict;
use warnings;
use Encode;
use Encode::JP::Mobile;

use Test::More;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/docomo-table.yaml");
plan tests => 2 * @$dat;

for my $r (@$dat) {
    my $sjis = pack "H*", $r->{sjis};
    my $unicode = chr hex $r->{unicode};
    is decode("x-sjis-docomo", $sjis), $unicode, $r->{unicode};
    is encode("x-sjis-docomo", $unicode), $sjis, $r->{unicode};
}



