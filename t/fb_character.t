use strict;
use warnings;
use Test::More tests => 6;
use Encode;
use Encode::JP::Mobile;

is encode('x-utf8-docomo', "\x{ECA2}", Encode::JP::Mobile::FB_CHARACTER), "(>３<)", 'utf-8 fallback';

is encode('x-utf8-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER), "(>３<)?", 'out of cp932';

# for Catalyst::Plugin::Unicode::Encoding
my $check = Encode::JP::Mobile::FB_CHARACTER;
my $encoding = find_encoding('x-utf8-docomo');
is $encoding->encode("\x{ECA2}", $check), "(>３<)", '$encoding->encode()';

is encode('x-sjis-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER), 
   encode('shift_jis', decode('utf-8', "(>３<)?")), 'shift_jis fallback';

is encode('x-sjis-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER(Encode::FB_XMLCREF) ), 
   encode('shift_jis', decode('utf-8', "(>３<)&#x2668;")), 'callback with Encode::FB_XMLCREF';

is encode('x-sjis-docomo', "\x{ECA2}\x{2668}", Encode::JP::Mobile::FB_CHARACTER(sub { "[x]" }) ), 
   encode('shift_jis', decode('utf-8', "(>３<)[x]")), 'callback with callback';

