package Encode::JP::Mobile;
our $VERSION = "0.14";

use Encode;
use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

use base qw( Exporter );
@EXPORT_OK = qw( InDoCoMoPictograms InKDDIPictograms InSoftBankPictograms InAirEdgePictograms InMobileJPPictograms );
%EXPORT_TAGS = ( props => [@EXPORT_OK] );

use Encode::Alias;
define_alias('x-sjis-docomo' => 'x-sjis-imode');
define_alias('x-sjis-ezweb' => 'x-sjis-kddi');
define_alias('x-sjis-ezweb-auto' => 'x-sjis-kddi-auto');
define_alias('x-sjis-airedge' => 'cp932');
define_alias('x-sjis-airh' => 'cp932');
define_alias('x-sjis-vodafone-auto' => 'x-sjis-softbank-auto');

# backward compatiblity
define_alias('shift_jis-imode' => 'x-sjis-imode');
define_alias('shift_jis-kddi' => 'x-sjis-kddi');
define_alias('shift_jis-kddi-auto' => 'x-sjis-kddi-auto');
define_alias('shift_jis-airedge' => 'cp932');
define_alias('shift_jis-docomo' => 'x-sjis-imode');
define_alias('shift_jis-ezweb' => 'x-sjis-kddi');
define_alias('shift_jis-ezweb-auto' => 'x-sjis-kddi-auto');
define_alias('shift_jis-airh' => 'cp932');

use Encode::JP::Mobile::Vodafone;
use Encode::JP::Mobile::KDDIJIS;

sub InDoCoMoPictograms {
    return <<END;
E63E\tE6A5
E6AC\tE6AE
E6B1\tE6B3
E6B7\tE6BA
E6CE\tE757
END
}

sub InKDDIPictograms {
    return <<END;
E468\tE5DF
EA80\tEB88
END
}

sub InSoftBankPictograms {
    return <<END;
E001\tE05A
E101\tE15A
E201\tE253
E255\tE257
E301\tE34D
E401\tE44C
E501\tE537
END
}

sub InAirEdgePictograms {
    return <<END;
E000\tE096
E098
E09A
E09F
E0A2
E0A6
E0A8
E0AF
E0BB
E0C4
E0C9
END
}

sub InMobileJPPictograms {
    # +utf8::InDoCoMoPictograms etc. don't work here
    return join "\n", InDoCoMoPictograms, InKDDIPictograms, InSoftBankPictograms, InAirEdgePictograms;
}

1;
__END__

=head1 NAME

Encode::JP::Mobile - Shift_JIS (CP932) variants of Japanese cellphone pictograms

=head1 SYNOPSIS

  use Encode;
  use Encode::JP::Mobile;

  my $bytes = "\x82\xb1\xf9\x5d\xf8\xa0\x82\xb1"; # Shift_JIS bytes containing NTT DoCoMo pictograms
  my $chars = decode("x-sjis-imode", $bytes);     # \x{3053}\x{e6b9}\x{e63f}\x{3053}

  use Encode::JP::Mobile ':props';
  if ($chars =~ /\p{InDoCoMoPictograms}/) {
      warn "It has DoCoMo pictogram characters!";
  }

=head1 DESCRIPTION

Encode::JP::Mobile is an Encode module to support Shift_JIS (CP032)
extended characters mapped in Unicode Private Area.

This module is B<EXPERIMENTAL>. That means API and implementations
will sometimge be backward incompatible.

=head1 ENCODINGS

This module currently supports the following encodings.

=over 4

=item x-sjis-imode

Mapping for NTT DoCoMo i-mode handsets. Pictograms are mapped in
Shift_JIS private area and Unicode private area. The conversion rule
is equivalent to that of cp932.

For example, C<U+E64E> is I<Fine> character (or I<The Sun>) and is
encoded as C<\xF8\x9F> in this encoding.

This encoding is a subset of cp932 encoding, but has a reverse mapping
from KDDI/AU Unicode private area characters to DoCoMo pictogram
encodings. For example,

  my $kddi  = "\xf6\x59"; # [!] in KDDI/AU
  my $char  = decode("x-sjis-kddi", $bytes); # \x{E481}
  my $imode = encode("x-sjis-imode", $char); # \xf9\xdc -- [!] in DoCoMo

I<x-sjis-docomo> is an alias.

=item x-sjis-softbank

Escape sequence based Shift_JIS encoding for SoftBank
pictograms. Decoding algorithm is not based on an ucm file, but a perl
code.

I<x-sjis-vodafone> is an alias.

For example, C<U+E001> is I<A Boy> character and is encoded
as C<\x1b$G!\x0f> in this encoding (C<\x1b$G> is the beginning of
escape sequence and C<\x0f> is the end.)

=item x-sjis-softbank-auto

Maps Unicode private area characters to Shift_JIS private area (Gaiji)
characters. This encoding is used in 3GC phones when you input
pictogram charaters in a web form on Shift_JIS pages and submit.
Handsets also can decode these encodings and display pictogram characters.

I<x-sjis-vodafone-auto> is an alias.

The private area mapping seems similar to CP932 but with a bit of
offset.

For example, U<+E001> is I<A Boy> character (same as
I<x-sjis-softbank>) and is encoded as I<\xF9\x41>.

=item x-sjis-kddi

Mapping for KDDI/AU pictograms. It's based on cp932 (I guess) but
there are more private characters that are not included in CP932.TXT.

For example, I<U+E481> is I<!> (the exclamation) character and is
encoded as I<\xF6\x59> (same as cp932). I<U+EB88> is I<Angry>
character and is encoded in I<\xF4\x8D> while cp932 doesn't have a map
for it.

I<x-sjis-ezweb> is an alias.

=item x-sjis-kddi-auto

Mapping for KDDI/AU pictograms, based on handset's internal Shift_JIS
to UTF-8 translations and vice verca. When you input some pictogram
characters in a web form on a UTF-8 page and submit them, this mapping
is used (instead of CP932 based I<x-sjis-kddi>) to represent the
pictogram characters.

I<x-sjis-kddi-auto> and I<x-sjis-kddi> shares Unicode to encoding
mapping each other and hence round-trip safe, which means:

  my $bytes = "\xf6\x59";                 # [!] in KDDI/AU
  decode("x-sjis-kddi", $bytes);          # \x{E481}
  decode("x-sjis-kddi-auto", $bytes);     # \x{EF59}
  encode("x-sjis-kddi", "\x{EF59}");      # same as $bytes
  encode("x-sjis-kddi-auto", "\x{E481}"); # same as $bytes

C<x-sjis-ezweb-auto> is an alias.

=item x-iso-2022-jp-kddi

Encoding used to encode KDDI/AU pictogram characters in Email. It's
based on I<iso-2022-jp> which is still a de-facto standard encoding
when we sned emails.

Actually most KDDI/AU cellphones can receive emails encoded in
Shift_JIS, so you can just use I<x-sjis-kddi> to encode the pictogram
characters. This encoding might be still needed to decode incoming
emails sent from KDDI/AU phones containing pictogram characters.

C<x-iso-2022-jp-ezweb> is an alias.

=item x-sjis-airedge

Mapping for AirEDGE pictograms. It's a complete subset of cp932C<x-sjis-airh> is an alias.

=back

=head1 UNICODE PROPERTIES

By importing this module with ':props' flag, you'll have following Unicode properties.

=over 4

=item InDoCoMoPictograms

=item InKDDIPictograms

=item InSoftBankPictograms

=item InAirEdgePictograms

=back

Note that if the input is one of x-sjis-* variants, first you need to
know what encoding the bytes are encoded, and decode the bytes back to
Unicode, to know if the strings contain these pictogram character
sets. So it might be only handy if the input is UTF-8 in reality.


=head1 BACKWARD COMPATIBLITY

As of 0.07, this module now uses I<x-sjis-*> as its encoding names. It
still supports the old I<shift_jis-*> aliases though. I'm planning to
deprecate them sometime in the future release.

=head1 NOTES

=over 4

=item *

Pictogram characters are defined to be round-trip safe. However, they
use Unicode Private Area for such characters, that means you'll have
interoperability issues, which this module doesn't try yet to solve
completely. We have a partial support for roundtrip (automatic
conversion) between I<x-sjis-imode> and I<x-sjis-kddi>.

=item *

As of version 0.04, this module tries to do auto-conversion of KDDI/AU
and NTT-DoCoMo pictogram characters. Supporting SoftBank characters
are still left TODO.

=back

=head1 TODO

=over 4

=item *

Implement all merged C<x-sjis-mobile-jp> encoding.

=back

=head1 AUTHORS

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software, licensed under the same terms with Perl.

=head1 SEE ALSO

L<Encode>, L<HTML::Entities::ImodePictogram>, L<Unicode::Japanese>

http://www.nttdocomo.co.jp/service/imode/make/content/pictograph/basic/
http://www.nttdocomo.co.jp/service/imode/make/content/pictograph/extention/
http://www.au.kddi.com/ezfactory/tec/spec/3.html
http://developers.softbankmobile.co.jp/dp/tool_dl/web/picword_top.php
http://www.willcom-inc.com/ja/service/contents_service/club_air_edge/for_phone/homepage/index.html
http://www.nttdocomo.co.jp/service/mail/imode_mail/emoji_convert/

=cut
