#!/usr/bin/perl
use strict;
use warnings;
use Encode;
use CAM::PDF;

my $file = shift or die "Usage: kddi-extract.pl typeD.pdf\n";
my $doc  = CAM::PDF->new($file);

my @res;
foreach my $p (1..$doc->numPages()) {
    my $text = decode("shift_jis", $doc->getPageText($p));
    while ($text =~ m/(\d+)(?: |[abcdef \x{FF43}\x{3000}]+|\x{306A}\x{3057} )([^ ]*) ([0-9A-F]{4})([0-9A-F]{4})([0-9A-F]{4})([0-9A-F]{4})/gs) {
        my %data;
        @data{qw( number name sjis unicode email_jis email_sjis )} = ($1, $2, $3, $4, $5, $6);
        $data{name} =~ s/\n//g;
        push @res, \%data;
    }
}

@res = sort { $a->{number} <=> $b->{number} } @res;

use YAML;
binmode STDOUT, ":utf8";
print Dump \@res;

@res == 641 or die "item count mismatch";

