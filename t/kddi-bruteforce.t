use strict;
use warnings;
use Encode;
use Encode::JP::Mobile;

use Test::More;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/kddi-table.yaml");
plan tests => 3 * @$dat;

for my $r (@$dat) {
    my $sjis = pack "H*", $r->{sjis};
    my $jis  = "\e\$B" . pack("H*", $r->{email_jis}) . "\e(B";

    my $unicode = chr hex $r->{unicode};
    is decode("x-sjis-kddi", $sjis), $unicode, $r->{unicode};
    is encode("x-sjis-kddi", $unicode), $sjis, $r->{unicode};
    is decode("x-iso-2022-jp-kddi", $jis), $unicode, $r->{unicode};
    #is encode("x-iso-2022-jp-kddi", $unicode), $jis, $r->{unicode};
}
