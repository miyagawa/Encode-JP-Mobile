use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 35;
use Encode;

my @WARN;
BEGIN {
    $SIG{__WARN__} = sub {
        push @WARN, shift;
    };
}

{
    use utf8;    # utf8 mode!

    use charnames ':full';

    is sprintf( "%X", unpack "U*", "\N{DIGIT SIX}" ), "36";
    is charnames::vianame('DIGIT SIX'),           0x36;
    is Encode::is_utf8("\N{HIRAGANA LETTER GA}"), 1;
    is Encode::is_utf8("\N{DIGIT SIX}"),          1;

    use Encode::JP::Mobile::Charnames
      qw( vianame unicode2name unicode2name_en );

    is charnames::vianame('DIGIT SIX'), 0x36;
    is vianame('DoCoMo Beer'),          0xE672;

    is unicode2name(0xE672), 'ビール';
    is unicode2name(0xE047), 'ビール';    # SoftBank

    is unicode2name(0xE5CC), '打ち上げ花火', 'ezweb-cp932';
    is unicode2name(0xF0FC), '打ち上げ花火', 'ezweb-auto';
    is unicode2name(0xE501), 'ラブホテル',
      'kddi-softbank conflict code. should return softbank code';
    ok Encode::is_utf8( unicode2name(0xE672) );

    is unicode2name_en(0xE672), 'Beer';      # DoCoMo
    is unicode2name_en(0xE4C3), 'Beer';      # KDDI-CP932
    is unicode2name_en(0xEF9C), 'Beer';      # KDDI-Auto
    is unicode2name_en(0xE047), 'Beer';      # SoftBank

    is "\N{DoCoMo Beer}",                     "\x{E672}";
    is "\N{DoCoMo ファーストフード}", "\x{E673}";
    is "\N{KDDI Beer}",                       "\x{E4C3}";
    is "\N{SoftBank Beer}",                   "\x{E047}";

    is "\N{DIGIT SIX}", "6";

    {
        my $x = "\N{UNKNOWN CHARACTER}";
        $x = vianame('DoCoMo Foo');
        is scalar(@WARN), 2, 'check warn num';
        like $WARN[0], qr{Unknown charname 'UNKNOWN CHARACTER'}, 'wanrings when unkown character';
        like $WARN[1], qr{unknown charnames: Foo}, 'warning when unkown character';
    }
    eval { unicode2name() }; like $@, qr{^missing code}, "validation";
    eval { unicode2name_en() }; like $@, qr{^missing code}, "validation";
    eval { vianame() }; like $@, qr{^missing name}, "validation";

    is Encode::is_utf8("\N{DoCoMo Beer}"),                     1;
    is Encode::is_utf8("\N{DoCoMo ファーストフード}"), 1;
    is Encode::is_utf8("\N{HIRAGANA LETTER GA}"),              1;
    is Encode::is_utf8("\N{DIGIT SIX}"),                       1;
}

{
    use bytes; # bytes mode!

    use charnames ':full';

    is Encode::is_utf8("\N{DIGIT SIX}") ? 'true' : 'false', 'false';
    ok "\N{DIGIT SIX}" eq '6';

    use Encode::JP::Mobile::Charnames;

    is Encode::is_utf8("\N{DIGIT SIX}") ? 'true' : 'false', 'false';
    ok "\N{DIGIT SIX}" eq '6';
}

