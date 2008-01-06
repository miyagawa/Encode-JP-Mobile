use strict;
use Test::More;
use Encode;
use Encode::JP::Mobile;

plan tests => 2 * 9 + 9;

simple_pair("\xEE\x98\xBE", "\xEE\xBD\xA0", "\xEE\x81\x8A"); # sunny
simple_pair("\xEE\x9B\xA5", "\xEF\x81\x81", "\xEE\x88\x9F"); # number 4

sub simple_pair {
    my ($docomo, $kddi, $softbank) = @_;
    
    is encode('x-utf8-docomo',   decode('utf-8', $docomo)), $docomo, 'I => I';
    is encode('x-utf8-kddi',     decode('utf-8', $docomo)), $kddi, 'I => E';
    is encode('x-utf8-softbank', decode('utf-8', $docomo)), $softbank, 'I => V';
    
    is encode('x-utf8-docomo',   decode('utf-8', $kddi)), $docomo;
    is encode('x-utf8-kddi',     decode('utf-8', $kddi)), $kddi, 'E => E';
    is encode('x-utf8-softbank', decode('utf-8', $kddi)), $softbank;
    
    is encode('x-utf8-docomo',   decode('utf-8', $softbank)), $docomo, 'V => I';
    is encode('x-utf8-kddi',     decode('utf-8', $softbank)), $kddi;
    is encode('x-utf8-softbank', decode('utf-8', $softbank)), $softbank;
}

{   # fish
    my $docomo   = "\xEE\x9D\x91";
    my $kddi     = "\xEE\xB3\x9E";
    my $softbank = "\xEE\x94\xA2";
    
    is encode('x-utf8-docomo',   decode('utf-8', $docomo)), $docomo;
    is encode('x-utf8-kddi',     decode('utf-8', $docomo)), "\xEE\xBD\xB2"; # kddi Pisces sign
    is encode('x-utf8-softbank', decode('utf-8', $docomo)), "\xEE\x80\x99"; # softbank Pisces sign
    
    is encode('x-utf8-docomo',   decode('utf-8', $kddi)), $docomo;
    is encode('x-utf8-kddi',     decode('utf-8', $kddi)), $kddi, 'E => E';
    is encode('x-utf8-softbank', decode('utf-8', $kddi)), $softbank;
    
    is encode('x-utf8-docomo',   decode('utf-8', $softbank)), $docomo;
    is encode('x-utf8-kddi',     decode('utf-8', $softbank)), $kddi, 'V => E';
    is encode('x-utf8-softbank', decode('utf-8', $softbank)), $softbank;
}

