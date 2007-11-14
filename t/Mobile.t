use strict;
use Test::More tests => 48;

use_ok('Encode');
use_ok('Encode::JP::Mobile');

test_rt("x-sjis-imode", "\x82\xb1\xf9\x5d\xf8\xa0\x82\xb1", "\x{3053}\x{e6b9}\x{e63f}\x{3053}");
test_rt("x-sjis-docomo", "\x82\xb1\xf9\x5d\xf8\xa0\x82\xb1", "\x{3053}\x{e6b9}\x{e63f}\x{3053}");
test_rt("x-sjis-kddi", "\x82\xb1\xF6\x59", "\x{3053}\x{e481}");
test_rt("x-sjis-kddi-auto", "\x82\xb1\xF6\x59", "\x{3053}\x{ef59}");
test_rt("x-sjis-ezweb", "\x82\xb1\xF6\x59", "\x{3053}\x{e481}");
test_rt("x-sjis-airedge", "\x82\xb1\xF0\x40", "\x{3053}\x{e000}");
test_rt("x-sjis-airh", "\x82\xb1\xF0\x40", "\x{3053}\x{e000}");
test_rt("x-sjis-vodafone", "\x82\xb1\x1b\x24\x47\x21\x22\x0f", "\x{3053}\x{e001}\x{e002}");
test_rt("x-sjis-softbank", "\x82\xb1\x1b\x24\x47\x21\x22\x0f", "\x{3053}\x{e001}\x{e002}");
test_rt("x-sjis-vodafone-auto", "\xfb\xa1\xfb\xa2", "\x{e501}\x{e502}");
test_rt("x-sjis-softbank-auto", "\xfb\xa1\xfb\xa2", "\x{e501}\x{e502}");

test_rt("x-sjis-vodafone", "\x82\xb1\x1b\x24\x45\x21\x22\x0f", "\x{3053}\x{e101}\x{e102}");
test_rt("x-sjis-softbank", "\x82\xb1\x1b\x24\x45\x21\x22\x0f", "\x{3053}\x{e101}\x{e102}");
test_rt("x-sjis-vodafone", "\x82\xb1\x1b\x24\x46\x21\x22\x0f", "\x{3053}\x{e201}\x{e202}");
test_rt("x-sjis-softbank", "\x82\xb1\x1b\x24\x46\x21\x22\x0f", "\x{3053}\x{e201}\x{e202}");
test_rt("x-sjis-vodafone", "\x82\xb1\x1b\x24\x4f\x21\x22\x0f", "\x{3053}\x{e301}\x{e302}");
test_rt("x-sjis-softbank", "\x82\xb1\x1b\x24\x4f\x21\x22\x0f", "\x{3053}\x{e301}\x{e302}");
test_rt("x-sjis-vodafone", "\x82\xb1\x1b\x24\x50\x21\x22\x0f", "\x{3053}\x{e401}\x{e402}");
test_rt("x-sjis-softbank", "\x82\xb1\x1b\x24\x50\x21\x22\x0f", "\x{3053}\x{e401}\x{e402}");
test_rt("x-sjis-vodafone", "\x82\xb1\x1b\x24\x51\x21\x22\x0f", "\x{3053}\x{e501}\x{e502}");
test_rt("x-sjis-softbank", "\x82\xb1\x1b\x24\x51\x21\x22\x0f", "\x{3053}\x{e501}\x{e502}");

test_rt("shift_jis-imode", "\x82\xb1\xf9\x5d\xf8\xa0\x82\xb1", "\x{3053}\x{e6b9}\x{e63f}\x{3053}");
test_rt("shift_jis-vodafone", "\x82\xb1\x1b\x24\x47\x21\x22\x0f", "\x{3053}\x{e001}\x{e002}");

sub test_rt {
    my ( $enc, $bytes, $uni ) = @_;
    is decode( $enc, $bytes ), $uni, "decode $enc";
    is encode( $enc, $uni ), $bytes, "encode $enc";
}
