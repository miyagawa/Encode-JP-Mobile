use strict;
use warnings;
use Test::More tests => 5;
use Encode::JP::Mobile;
use Encode::JP::Mobile::KDDIJIS;
use Encode;
use Data::Dumper;

is decode("x-iso-2022-jp-kddi", "\e\$B\x75\x41\e(B"), "\x{E488}";
is decode("x-iso-2022-jp-kddi", "\e\$B\x75\x41\x76\x76\e(B"), "\x{e488}\x{e51b}";
is decode('x-iso-2022-jp-kddi', encode('iso-2022-jp', decode("utf8", "お"))), decode('utf8', "お"), 'o';
is decode('x-iso-2022-jp-kddi', encode('iso-2022-jp', decode("utf8", "おいおい。山岡くん。kanbenしてくれよ！"))), decode('utf8', "おいおい。山岡くん。kanbenしてくれよ！"), 'kanji, hiragana, alphabet';
is decode('x-iso-2022-jp-kddi', "\e\(I\x54\x2F\x4E\x5F\e(B"), decode('utf8', "ﾔｯﾎﾟ"), 'half width katakana';
# is decode('x-iso-2022-jp-kddi', "\e\$(D\x2B\x21\x30\x57\e(B"), "\x{00E1}\x{4F0C}", 'JIS X 0212';

