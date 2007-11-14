#!/usr/bin/perl
use strict;
use warnings;
use YAML;

my($file, $what) = @ARGV;
my $dat = YAML::LoadFile($file);
for my $r (@$dat) {
    printf "<U%s> %s |0 # $what\n", $r->{unicode}, hexify($r->{sjis});
}

sub hexify {
    my $hex  = shift;
    $hex =~ s/(..)/\\x$1/g;
    $hex;
}


