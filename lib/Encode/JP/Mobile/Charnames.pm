package Encode::JP::Mobile::Charnames;
use strict;
use warnings;
use charnames ();
use bytes     ();
use File::ShareDir 'dist_file';
use Carp;
use Encode;

my $name2unicode;
my $unicode2name;
my $unicode2name_en;

sub import {
    my $class = shift;
    # for perl < 5.10
    if ($charnames::hint_bits) {
        $^H |= $charnames::hint_bits;
    }
    $^H{charnames} = \&translator;
}

sub translator {
    if ( $^H & $bytes::hint_bits ) {
        bytes_translator(@_);
    }
    else {
        unicode_translator(@_);
    }
}

my $re = qr/^(DoCoMo|KDDI|SoftBank) (.+)$/o;

sub unicode_translator {
    my $name = shift;

    if ( my ( $carrier, $r_name ) = ( $name =~ $re ) ) {
        unless ($name2unicode) {
            _mk_name2unicode_map();
        }

        my $ret = $name2unicode->{$r_name};
        if ( defined $ret ) {
            return pack "U*", $ret;
        }
        else {
            carp "unknown charnames: $r_name";
        }
    }
    else {
        return charnames::charnames($name);
    }
}

# XXX pictograms are only in the above 0xFF area.
sub bytes_translator {
    my $name = shift;
    return charnames::charnames($name);
}

sub _mk_name2unicode_map {
    for my $carrier (qw/docomo kddi softbank/) {
        my $fname = dist_file( 'Encode-JP-Mobile', "${carrier}-table.pl" );
        my $dat = do $fname;

        for my $row (@$dat) {
            next unless $row->{name};
            $name2unicode->{ $row->{name} } = hex $row->{unicode};
            if ( $row->{en_name} ) {
                $name2unicode->{ $row->{en_name} } = hex $row->{unicode};
            }
        }
    }
}

sub _mk_unicode2name_map {
    for my $carrier (qw/docomo kddi softbank/) {
        my $fname = dist_file( 'Encode-JP-Mobile', "${carrier}-table.pl" );
        my $dat = do $fname;

        for my $row (@$dat) {
            $unicode2name->{ hex $row->{unicode} } = decode('utf8', $row->{name});
            if ($carrier eq 'kddi') {
                $unicode2name->{ hex $row->{unicode_auto} } = decode('utf8', $row->{name});
            }
        }
    }
}

sub _mk_unicode2name_en_map {
    for my $carrier (qw/docomo/) {
        my $fname = dist_file( 'Encode-JP-Mobile', "${carrier}-table.pl" );
        my $dat = do $fname;

        for my $row (@$dat) {
            $unicode2name_en->{ hex $row->{unicode} } = $row->{en_name};
        }
    }
}

sub vianame {
    my $name = shift;
    croak "missing name" unless $name;

    if ( my ( $carrier, $r_name ) = ( $name =~ $re ) ) {
        unless ($name2unicode) {
            _mk_name2unicode_map();
        }

        return $name2unicode->{$r_name} || carp "unknown charnames: $r_name";
    }
    else {
        return charnames::vianame($name);
    }
}

sub unicode2name {
    my $code = shift;
    croak "missing code" unless $code;

    unless ($unicode2name) {
        _mk_unicode2name_map();
    }

    return $unicode2name->{$code};
}

sub unicode2name_en {
    my $code = shift;
    croak "missing code" unless $code;

    unless ($unicode2name_en) {
        _mk_unicode2name_en_map();
    }

    return $unicode2name_en->{$code};
}

1;
__END__

=encoding utf-8

=head1 NAME

Encode::JP::Mobile::Charnames - define pictogram names for "\N{named}" string literal escapes

=head1 SYNOPSIS

    use Encode::JP::Mobile::Charnames;

    print "\N{DoCoMo Beer} \N{DoCoMo ファーストフード}\n";
    Encode::JP::Mobile::Charnames::unicode2name(0xE672);    # => 'ビール'
    Encode::JP::Mobile::Charnames::unicode2name_en(0xE672); # => 'Beer'
    Encode::JP::Mobile::Charnames::vianame('DoCoMo Beer');  # => 0xE672

=head1 METHODS

=item unicode2name

    Encode::JP::Mobile::Charnames::unicode2name(0xE672);    # => 'ビール'

unicode から日本語の名前を得ます。

このメソッドは KDDI-cp932 と KDDI-Auto のどちらの Unicode が引数として渡されても名前を返します。

ただし、現在の仕様では、softbank と au の重複領域では softbank が優先されます。
シェアを考えれば KDDI の方を優先するべきですが、KDDI の方は KDDI-CP932 ではなく
KDDI-Auto を使うという代替手法があるので、このような仕様となっております。

=item unicode2name_en

    Encode::JP::Mobile::Charnames::unicode2name_en(0xE672); # => 'Beer'

Unicode から英語の名前を得ます。

キャリヤから公式に英語の絵文字名称が付与されているのは docomo だけであるため、現在は docomo 絵文字
のみの対応となっています。

(他のキャリヤも英語名称公開してくれるとうれしいなあ)

=item vianame

    Encode::JP::Mobile::Charnames::vianame('DoCoMo Beer');  # => 0xE672

名前から絵文字の Unicode を得ます

=head1 AUTHOR

Tokuhiro Matsuno <tokuhirom ta mfac ・ jp>

=head1 SEE ALSO

L<Encode::JP::Mobile>, L<charnames>

