use strict;
use warnings;
use Encode;
use Encode::JP::Mobile;
use Test::More tests => 6;

my $sjis     = "\xf6\x59";
my $kddi_unicode = "\x{E481}";
my $auto_unicode = "\x{EF59}";

roundtrip($sjis);

sub roundtrip {
    my $bytes = shift;
    is decode("x-sjis-kddi", $bytes), $kddi_unicode;
    is encode("x-sjis-kddi", $kddi_unicode), $sjis;
    is encode("x-sjis-kddi-auto", $kddi_unicode), $sjis;
    is decode("x-sjis-kddi-auto", $bytes), $auto_unicode;
    is encode("x-sjis-kddi-auto", $auto_unicode), $sjis;
    is encode("x-sjis-kddi", $auto_unicode), $sjis;
}

