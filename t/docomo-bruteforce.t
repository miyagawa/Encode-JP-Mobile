use strict;
use warnings;
use Encode;
use Encode::JP::Mobile;

use Test::More;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/docomo-names.yaml");
plan tests => 1 * @$dat;

for my $r (@$dat) {
    my $sjis = pack "H*", $r->{sjis};
    is decode("x-sjis-docomo", $sjis), chr(hex($r->{unicode})), $r->{unicode};
}


