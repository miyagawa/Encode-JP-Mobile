use strict;
use warnings;
use Test::More tests => 2;
use Encode;
use Encode::JP::Mobile;

{
    my $u = "\x{0647}";
    is encode("x-sjis-vodafone", $u, Encode::FB_HTMLCREF), "&#1607;";
}

{
    my $u = "\x{0647}";
    my $var = encode("x-sjis-vodafone", $u, sub { "x" . $_[0] });
    is $var, "x1607";
}


