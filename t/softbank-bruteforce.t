use strict;
use warnings;
use Test::More;

use Encode;
use Encode::JP::Mobile;

eval { require YAML };
plan skip_all => $@ if $@;

my $dat = YAML::LoadFile("dat/softbank-table.yaml");

plan tests => 1 * @$dat;

for my $r (@$dat) {
    my $str = decode("x-sjis-softbank", $r->{char});
    is ord($str), hex($r->{code}), $r->{code};
}
