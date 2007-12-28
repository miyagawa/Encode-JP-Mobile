use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 20;
use Encode;

use utf8; # utf8 mode!

use charnames ':full';

is sprintf("%X", unpack "U*", "\N{DIGIT SIX}"), "36";
is charnames::vianame('DIGIT SIX'), 0x36;
is Encode::is_utf8("\N{HIRAGANA LETTER GA}"), 1;
is Encode::is_utf8("\N{DIGIT SIX}"), 1;

use Encode::JP::Mobile::Charnames;

is charnames::vianame('DIGIT SIX'), 0x36;
is Encode::JP::Mobile::Charnames::vianame('DoCoMo Beer'), 0xE672;

is Encode::JP::Mobile::Charnames::unicode2name(0xE672), 'ビール';
is Encode::is_utf8(Encode::JP::Mobile::Charnames::unicode2name(0xE672)), 1;
is Encode::JP::Mobile::Charnames::unicode2name_en(0xE672), 'Beer';

is sprintf("%X", unpack "U*", "\N{DoCoMo Beer}"), "E672";
is sprintf("%X", unpack "U*", "\N{DoCoMo ファーストフード}"), "E673";
is sprintf("%X", unpack "U*", "\N{DIGIT SIX}"), "36";

is Encode::is_utf8("\N{DoCoMo Beer}"), 1;
is Encode::is_utf8("\N{DoCoMo ファーストフード}"), 1;
is Encode::is_utf8("\N{HIRAGANA LETTER GA}"), 1;
is Encode::is_utf8("\N{DIGIT SIX}"), 1;

use bytes; # bytes mode!

use charnames ':full';

is Encode::is_utf8("\N{DIGIT SIX}") ? 'true' : 'false', 'false';
ok "\N{DIGIT SIX}" eq '6';

use Encode::JP::Mobile::Charnames;

is Encode::is_utf8("\N{DIGIT SIX}") ? 'true' : 'false', 'false';
ok "\N{DIGIT SIX}" eq '6';

