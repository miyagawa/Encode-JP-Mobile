use strict;
use warnings;
use Test::More tests => 1;
use Encode;
use Encode::JP::Mobile;

is encode('x-utf8-docomo', "\x{ECA2}", \&Encode::JP::Mobile::FB_CHARACTER), "(>３<)";

