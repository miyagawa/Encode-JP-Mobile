package Encode::JP::Mobile::Character;
use strict;
use warnings;
use Encode;
use Encode::JP::Mobile::Charnames;
use Encode::JP::Mobile ':props';
use File::ShareDir 'dist_file';
use Carp;

sub from_unicode {
    my ($class, $unicode) = @_;
    bless {unicode => $unicode}, $class;
}

sub from_number {
    my $class = shift;
    my %args = @_;
    my $carrier = $args{carrier} or croak "missing carrier";
    my $number = $args{number} or croak "missing number";

    my $dat = $class->_load_map;

    $carrier = +{I => 'docomo', E => 'kddi', V => 'softbank', 'H' => 'docomo'}->{$carrier};
    $number = encode_utf8($number);

    my $key = $carrier eq 'kddi' ? 'unicode_auto' : 'unicode';
    for my $row (@{$dat->{$carrier}}) {
        if ($row->{number} eq $number) {
            return $class->from_unicode(hex $row->{$key});
        }
    }
    croak "unknown number: $number for $carrier";
}

sub unicode_hex {
    my ($class, ) = @_;
    sprintf '%X', $class->{unicode};
}

my $map;
sub _load_map {
    $map ||= +{
        map { $_, do( dist_file( 'Encode-JP-Mobile', "${_}-table.pl" ) ) }
          qw/docomo kddi softbank/
    };

    return $map;
}

sub name {
    my $self = shift;

    my $dat = $self->_load_map;

    for my $carrier (keys %$dat) {
        my $key = $carrier eq 'kddi' ? 'unicode_auto' : 'unicode';
        for my $row (@{ $dat->{$carrier} }) {
            next unless exists $row->{'name'};
            if (hex($row->{$key}) == $self->{unicode}) {
                return decode_utf8($row->{name});
            }
        }
    }

    return;
}

sub number {
    my $self = shift;

    my $dat = $self->_load_map;

    for my $carrier (keys %$dat) {
        my $key = $carrier eq 'kddi' ? 'unicode_auto' : 'unicode';
        for my $row (@{ $dat->{$carrier} }) {
            next unless exists $row->{'number'};
            if (hex($row->{$key}) == $self->{unicode}) {
                return decode_utf8($row->{number});
            }
        }
    }

    return;
}

my $fallback_name_cache;
sub fallback_name {
    my ($self, $carrier) = @_;
    croak "missing carrier" unless $carrier;
    croak "invalid carrier name(I or E or V)" unless $carrier =~ /^[IEVH]$/;

    $fallback_name_cache ||= do {
        my $src = dist_file('Encode-JP-Mobile', 'convert-map-utf8.pl');
        do $src;
    };

    $carrier = +{I => 'docomo', E => 'kddi', V => 'softbank', 'H' => 'docomo'}->{$carrier};

    for my $from (keys %$fallback_name_cache) {
        if (my $row = $fallback_name_cache->{$from}->{sprintf '%X', $self->{unicode}}->{$carrier}) {
            if ($row->{type} eq 'name') {
                return decode 'utf8', $row->{unicode};
            } else {
                return;
            }
        }
    }
    return;
}

sub carrier {
    my $self = shift;
    my $uni = chr $self->{unicode};
    if ($uni =~ /\p{InDoCoMoPictograms}/) {
        return 'I';
    } elsif ($uni =~ /\p{InSoftBankPictograms}/) {
        return 'V';
    } elsif ($uni =~ /\p{InKDDIAutoPictograms}/) {
        return 'E';
    } else {
        return;
    }
}

1;
__END__

=encodings utf8

=head1 NAME

Encode::JP::Mobile::Character - pictogram character object

=head1 SYNOPSIS

    my $char = Encode::JP::Mobile::Character->from_unicode(0xE63E);
    $char->name; # => 晴れ

=head1 DESCRIPTION

絵文字の文字を表現するオブジェクトです。

=head1 METHODS

=over 4

=item from_unicode

    my $char = Encode::JP::Mobile::Character->from_unicode(0xE63E);

unicode からインスタンスをつくります。

=item from_name

    my $char = Encode::JP::Mobile::Character->from_name(
        carrier => 'I',
        number  => "拡76",
    );

絵文字番号からインスタンスをつくります。

=item name

    $char->name; # => 晴れ

絵文字の名称を得ます。

=item unicode_hex

    $char->unicode_hex; # => "E63E"

ユニコードの16進数4桁による文字列の表現を返します。

=item fallback_name

    $char->fallback_name('I'); # => (>３<)

メール受信時のキャリヤ間相互絵文字変換において、絵文字に変換されないときに変換される文字列です。

引数は I, E, V, H のうちいずれかで、これは HTTP::MobileAgent 準拠です。

=item number

    $char->number;

絵文字番号を得ます。

DoCoMo の場合には「拡76」のような文字列が返ってくることに注意してください。

=item carrier

    $char->carrier;

キャリヤを得ます。L<HTTP::MobileAgent> と同じ規則により、I, E, V のうちいずれかを返します。
絵文字ではない場合には、undef を返します。

=back

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<Encode::JP::Mobile>
