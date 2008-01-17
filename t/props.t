use strict;
use warnings;
use Test::More tests => 5;
use Encode::JP::Mobile ':props';

ok InKDDISoftBankConflicts();

ok "\x{E501}" =~ /\p{InKDDISoftBankConflicts}/;
ok "\x{E44C}" !~ /\p{InKDDISoftBankConflicts}/;

my $possibly_kddi = "\x{E589} \x{E501}"; # E589 is only in KDDI
is guess_carrier($possibly_kddi), "kddi";

my $possibly_softbank = "\x{E44C} \x{E501}"; # E44C is only in SoftBank
is guess_carrier($possibly_softbank), "softbank";

sub guess_carrier {
    my $string = shift;
    if ($string =~ /\p{InKDDISoftBankConflicts}/) {
        eval { Encode::encode("x-sjis-kddi", $string, Encode::FB_CROAK) };
        if ($@) {
            return 'softbank';
        } else {
            return 'kddi';
        }
    }

    return;
}
