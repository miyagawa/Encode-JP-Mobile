package Encode::JP::Mobile::ConvertPictgramSJIS;
use strict;
use warnings;
use Encode::Alias;

# sjis
define_alias('x-sjis-imode'         => 'x-sjis-docomo');
define_alias('x-sjis-ezweb-auto'    => 'x-sjis-kddi-auto');
define_alias('x-sjis-airedge'       => 'x-sjis-airh');
define_alias('x-sjis-vodafone'      => 'x-sjis-softbank');
define_alias('x-sjis-vodafone-auto' => 'x-sjis-softbank-auto');

# backward compatiblity
define_alias('shift_jis-imode'      => 'x-sjis-imode');
define_alias('shift_jis-kddi-auto'  => 'x-sjis-kddi-auto');
define_alias('shift_jis-airedge'    => 'x-sjis-airh');
define_alias('shift_jis-docomo'     => 'x-sjis-imode');
define_alias('shift_jis-ezweb'      => 'x-sjis-kddi');
define_alias('shift_jis-ezweb-auto' => 'x-sjis-kddi-auto');
define_alias('shift_jis-airh'       => 'x-sjis-airh');


define_alias('shift_jis-softbank' => 'x-sjis-softbank');
define_alias('shift_jis-vodafone' => 'x-sjis-vodafone');

no strict 'refs';
for my $carrier (qw/docomo softbank softbank-auto kddi-auto airh/) {
    my $pkg = "Encode::JP::Mobile::_ConvertPictGramSJIS${carrier}";
    @{"$pkg\::ISA"} = 'Encode::Encoding';
    $pkg->Define("x-sjis-$carrier");

    *{"$pkg\::decode"} = sub ($$;$) {
        my($self, $char, $check) = @_;
        my $str = Encode::decode("x-sjis-$carrier-raw", $char);
        $_[1] = $str if $check;
        $str;
    };

    *{"$pkg\::encode"} = sub ($$;$) {
        my($self, $str, $check) = @_;

        my $utf8_encoding = "x-utf8-$carrier";
        $utf8_encoding =~ s/-auto$//;
        $utf8_encoding =~ s/-airh$/-docomo/;

        $str = Encode::encode($utf8_encoding, $str, $check);
        $str = Encode::decode($utf8_encoding, $str, $check);
        $str = Encode::encode("x-sjis-${carrier}-raw", $str, $check);

        $_[1] = $str if $check;
        $str;
    }
}



1;
__END__

=head1 NAME

Encode::JP::Mobile::ConvertPictgramSJIS - Pictogram characters conversion at x-sjis encoded

=head1 SYNOPSIS

    use Encode::JP::Mobile;
    
    # DoCoMo sunny mark post-ed from charset=sjis page.
    my $text = "\xF8\x9F";
    $text = decode('x-sjis-docomo', $text);
    
    print encode('x-sjis-kddi-convert_pictgram', $text); # KDDI sunny mark (\xF6\x60)
    print encode('x-sjis-softbank-auto-convert_pictgram', $text); # SoftBank sunny mark (\xF9\x8B)
    

=head1 AUTHOR

Masahiro Chiba

=head1 SEE ALSO

L<Encode::JP::Mobile>

