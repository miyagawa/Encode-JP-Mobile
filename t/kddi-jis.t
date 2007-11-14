use strict;
use warnings;
use Test::More tests => 25;
use Encode::JP::Mobile;
use Encode::JP::Mobile::KDDIJIS;
use Encode;

sub test_it {
    my ($jis, $uni, $case) = @_;
    $case ||= unpack "H*", $uni;

    is decode("x-iso-2022-jp-kddi", $jis), $uni, "decoding $case";
    is $jis, encode("x-iso-2022-jp-kddi", $uni), "encoding $case";

    # test kddi-auto Unicode chars as well ... rare in reality though
    my $bytes = $jis;
    Encode::from_to($bytes, "x-iso-2022-jp-kddi" => "x-sjis-kddi");
    Encode::from_to($bytes, "x-sjis-kddi-auto", "x-iso-2022-jp-kddi");
    is $bytes, $jis, "x-sjis-kddi-auto $case";
}

test_it("\e\$B\x75\x41\e(B", "\x{E488}", "pictogram");

test_it "a", decode('utf8', 'a'), 'alphabet';
test_it "\e\$B\x24\x57\e\(B", "\x{3077}", 'kanji(tora)';

is encode('x-iso-2022-jp-kddi', "\x{5bc5}"), encode('iso-2022-jp', "\x{5bc5}"), "kanji";

test_it "\e\$B\x75\x41\e(B", "\x{E488}", 'pictogram';
test_it "\e\$B\x75\x41\x76\x76\e(B", "\x{e488}\x{e51b}", 'pictogram';
test_it encode('iso-2022-jp', decode("utf8", "お")), decode('utf8', "お"), 'o';
test_it encode('iso-2022-jp', decode("utf8", "おいおい。山岡くん。kanbenしてくれよ！表示。")), decode('utf8', "おいおい。山岡くん。kanbenしてくれよ！表示。"), 'kanji, hiragana, alphabet';
test_it "\e\(I\x54\x2F\x4E\x5F\e(B", decode('utf8', "ﾔｯﾎﾟ"), 'half width katakana';

# is decode('x-iso-2022-jp-kddi', "\e\$(D\x2B\x21\x30\x57\e(B"), "\x{00E1}\x{4F0C}", 'JIS X 0212';
