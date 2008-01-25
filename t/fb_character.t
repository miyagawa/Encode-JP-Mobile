use strict;
use warnings;
use Test::More tests => 5;
use Encode;
use Encode::JP::Mobile;

is encode('x-utf8-docomo', "\x{ECA2}", Encode::JP::Mobile::FB_CHARACTER), "(>３<)";

is encode('x-utf8-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER), "(>３<)?";


is encode('x-sjis-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER), 
   encode('shift_jis', decode('utf-8', "(>３<)?"));

is encode('x-sjis-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER(Encode::FB_XMLCREF) ), 
   encode('shift_jis', decode('utf-8', "(>３<)&#x2668;"));

is encode('x-sjis-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER(sub { "[x]" }) ), 
   encode('shift_jis', decode('utf-8', "(>３<)[x]"));

