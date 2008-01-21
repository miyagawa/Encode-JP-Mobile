use strict;
use warnings;
use Test::More;

unless (grep { -e "$_/ucmlint" } split /:/, $ENV{PATH}) {
    plan skip_all => "ucmlint is not in your PATH";
}

my @ucm = glob("ucm/*.ucm");
plan tests => 1*@ucm;

for my $ucm (@ucm) {
    my $res = `ucmlint $ucm`;
    like $res, qr/no error found/, "$ucm is good";
}


