use strict;
use warnings;
use Encode;
use Encode::JP::Mobile;
use Encode::JP::Mobile::KDDIJIS;

use Test::More;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/kddi-table.yaml");
plan tests => 1 * @$dat;

for my $r (@$dat) {
    my $jis = pack "H*", $r->{email_jis};
    $jis = "\e\$B$jis\e(B";
    is decode("x-iso-2022-jp-kddi", $jis), chr(hex($r->{unicode})), "$r->{email_jis} => $r->{unicode}";
}

