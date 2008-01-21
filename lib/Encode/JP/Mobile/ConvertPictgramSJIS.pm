package Encode::JP::Mobile::ConvertPictgramSJIS;
use strict;
use warnings;
use Encode::Alias;

define_alias('x-sjis-imode-convert_pictgram'         => 'x-sjis-docomo-convert_pictgram');
define_alias('x-sjis-ezweb-convert_pictgram'         => 'x-sjis-kddi-convert_pictgram');
define_alias('x-sjis-kddi-auto-convert_pictgram'     => 'x-sjis-kddi-convert_pictgram');
define_alias('x-sjis-ezweb-auto-convert_pictgram'    => 'x-sjis-kddi-convert_pictgram');
define_alias('x-sjis-vodafone-auto-convert_pictgram' => 'x-sjis-softbank-auto-convert_pictgram');
define_alias('x-sjis-vodafone-convert_pictgram'      => 'x-sjis-softbank-convert_pictgram');

no strict 'refs';
for my $carrier (qw/docomo softbank softbank-auto kddi/) {
    my $pkg = "Encode::JP::Mobile::_ConvertPictGramSJIS${carrier}";
    @{"$pkg\::ISA"} = 'Encode::Encoding';
    $pkg->Define("x-sjis-$carrier-convert_pictgram");

    *{"$pkg\::decode"} = sub ($$;$) {
        my($self, $char, $check) = @_;
        my $str = Encode::decode("x-sjis-$carrier", $char);
        $_[1] = $str if $check;
        $str;
    };

    *{"$pkg\::encode"} = sub ($$;$) {
        my($self, $str, $check) = @_;

        my $trim_auto_carrier = $carrier;
        $trim_auto_carrier =~ s/-auto$//;

        $str = Encode::encode("x-utf8-${trim_auto_carrier}", $str, $check);
        $str = Encode::decode("x-utf8-${trim_auto_carrier}", $str, $check);
        $str = Encode::encode("x-sjis-${carrier}", $str, $check);

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

