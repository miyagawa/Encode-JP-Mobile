use strict;
use warnings;
use Encode::JP::Mobile;
use Test::More tests => 2;

my $sjis     = "\xf6\x41";
my $kddi_utf = "\xee\x91\xa9";
my $auto_utf = "\xee\xbd\x81";

kddi_to_auto($kddi_utf);

sub kddi_to_auto {
    my $bytes = shift;
    Encode::from_to($bytes, "utf-8" => "x-sjis-kddi");
    is $bytes, $sjis;
    Encode::from_to($bytes, "x-sjis-kddi-auto" => "utf-8");
    is $bytes, $auto_utf;
}

