use strict;
use Test::More;
use Encode;
use Encode::JP::Mobile;

plan tests => 3 * 9 + 9;

simple_pair(docomo => "\xEE\x98\xBE", kddi => "\xEE\xBD\xA0", softbank => "\xEE\x81\x8A"); # sunny
simple_pair(docomo => "\xEE\x9B\xA5", kddi => "\xEF\x81\x81", softbank => "\xEE\x88\x9F"); # number 4
simple_pair(docomo => "\xee\x98\xbe", kddi => "\xee\xbd\xa0", softbank => "\xee\x81\x8a");

sub _h {
    # for better Test::More log
    my $bytes = shift;
    my $out = unpack "H*", $bytes;
    $out =~ s/(..)/\\x$1/g;
    $out;
}

sub simple_pair {
    my(%args) = @_;

    my @test = qw( docomo kddi softbank );
    for my $from (@test) {
        for my $to (@test) {
            my $char = decode("x-utf8-" . $from, $args{$from});
            my $hex  = sprintf '%X', ord $char;
            is _h(encode("x-utf8-" . $to, $char)), _h($args{$to}), "$from -> $to (U+$hex)";
        }
    }
}

{   # fish
    my $docomo   = "\xEE\x9D\x91";
    my $kddi     = "\xEE\xB3\x9E";
    my $softbank = "\xEE\x94\xA2";

    is encode('x-utf8-docomo',   decode('x-utf8-docomo', $docomo)), $docomo;
    is encode('x-utf8-kddi',     decode('x-utf8-docomo', $docomo)), "\xEE\xBD\xB2"; # kddi Pisces sign
    is encode('x-utf8-softbank', decode('x-utf8-docomo', $docomo)), "\xEE\x80\x99"; # softbank Pisces sign

    is encode('x-utf8-docomo',   decode('x-utf8-kddi', $kddi)), $docomo;
    is encode('x-utf8-kddi',     decode('x-utf8-kddi', $kddi)), $kddi, 'E => E';
    is encode('x-utf8-softbank', decode('x-utf8-kddi', $kddi)), $softbank;

    is encode('x-utf8-docomo',   decode('x-utf8-softbank', $softbank)), $docomo;
    is encode('x-utf8-kddi',     decode('x-utf8-softbank', $softbank)), $kddi, 'V => E';
    is encode('x-utf8-softbank', decode('x-utf8-softbank', $softbank)), $softbank;
}

