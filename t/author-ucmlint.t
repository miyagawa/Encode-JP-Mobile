use strict;
use warnings;
use Test::More;

my @ucm = glob("ucm/*.ucm");
plan tests => 1*@ucm;

for my $ucm (@ucm) {
    my $res = `ucmlint $ucm`;
    like $res, qr/no error found/, "$ucm is good";
}


