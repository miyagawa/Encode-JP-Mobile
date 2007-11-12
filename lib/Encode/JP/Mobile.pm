package Encode::JP::Mobile;
our $VERSION = "0.10";

use Encode;
use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

use Encode::Alias;
define_alias('x-sjis-docomo' => 'x-sjis-imode');
define_alias('x-sjis-ezweb' => 'x-sjis-kddi');
define_alias('x-sjis-ezweb-auto' => 'x-sjis-kddi-auto');
define_alias('x-sjis-airedge' => 'cp932');
define_alias('x-sjis-airh' => 'cp932');

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

1;
__END__

=head1 NAME

Encode::JP::Mobile - Shift_JIS variants of Japanese Mobile phones

=head1 SYNOPSIS

  use Encode::JP::Mobile;

  my $char   = "\x82\xb1\xf9\x5d\xf8\xa0\x82\xb1";
  my $string = decode("x-sjis-imode", $char);

=head1 DESCRIPTION

Encode::JP::Mobile is an Encode module to support Shift_JIS variants used in Japaese mobile phone browsers.

This module is B<EXPERIMENTAL>. That means API and implementations will sometimge be backward incompatible.

=head1 ENCODINGS

This module currently supports the following encodings.

=over 4

=item x-sjis-imode

for DoCoMo pictograms. C<x-sjis-docomo> is alias.

=item x-sjis-softbank

for Softbank pictograms. Since it uses escape sequences, decoding
algorithm is not based on an ucm file. C<x-sjis-vodafone> is alias.

=item x-sjis-kddi

for KDDI/AU pictograms based on their specification. C<x-sjis-ezweb>
is alias.

=item x-sjis-kddi-auto

for KDDI/AU pictograms based on handset's SJIS code and UTF-8
translations. C<x-sjis-ezweb-auto> is alias.

=item x-sjis-airedge

for AirEDGE pictograms. C<x-sjis-airh> is alias.

=back

=head1 BACKWARD COMPATIBLITY

As of 0.07, this module now uses I<x-sjis-*> as its encoding names. It
still supports the old I<shift_jis-*> aliases though. I'm planning to
deprecate them sometime in the future release.

=head1 NOTES

=over 4

=item *

ucm files are based on C<cp932.ucm>, not C<shiftjis.ucm>, since it
looks more appropriate for possible use cases. I'm open for any
suggesitions on this matter.

=item *

Pictogram characters are defined to be round-trip safe. However, they
use Unicode Private Area for such characters, that means you'll have
interoperability issues, which this module doesn't try yet to solve
completely.

=item *

As of version 0.04, this module tries to do auto-conversion of KDDI/AU
and NTT-DoCoMo pictogram characters. Supporting Softbank characters
are still left TODO.

=back

=head1 TODO

=over 4

=item *

Support KDDI encodings for 7bit E-mail (C<x-iso-2022-jp-kddi>).

=item *

Implement all merged C<x-sjis-mobile-jp> encoding.

=back

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software, licensed under the same terms with Perl.

=head1 SEE ALSO

L<Encode>, L<HTML::Entities::ImodePictogram>

http://www.nttdocomo.co.jp/p_s/imode/make/emoji/
http://www.au.kddi.com/ezfactory/tec/spec/3.html
http://developers.vodafone.jp/dp/tool_dl/web/picword_top.php
http://www.willcom-inc.com/p_s/products/airh_phone/homepage.html

=cut
