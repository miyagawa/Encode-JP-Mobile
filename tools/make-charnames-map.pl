#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use YAML;
use FindBin;
use File::Spec::Functions;

$Data::Dumper::Terse++;

for my $carrier (qw/docomo softbank kddi/) {
    my $src_fname = catfile($FindBin::Bin, '..', 'dat', "${carrier}-table.yaml");
    my $dst_fname = catfile($FindBin::Bin, '..', 'dat', "${carrier}-table.pl");

    open my $fh, '>', $dst_fname or die $!;
    print $fh Dumper(YAML::LoadFile($src_fname));
    close $fh;
}

