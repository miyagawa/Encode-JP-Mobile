#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use Path::Class;
use YAML;

&main; exit;

sub main {
    my $cp932 = file( $FindBin::Bin, '..', 'ucm', 'cp932.ucm' )->openr;
    print header();
    while (<$cp932>) {
        next if /^#/;
        next if /<code_set_name> "cp932"/;
        next if /PRIVATE USE AREA/;
        next if /END CHARMAP/;

        # x-sjis-softbank-auto ではIBM拡張漢字の領域をつぶして絵文字用につかっている模様。
        # たとえば、U+52AF は IBM EXT では \xFB\x77 で、NEC EXT. では \xEE\x5B と表現できる(see cp932.ucm)
        # このうち、\xFB\x77 の方を絵文字領域として使用しているのだ。
        if (/^<U[0-9A-F]+> (\S+) \|\d/) {
            if (in_softbank_pictogram($1)) {
                next;
            }
        }

        print $_;
    }
    print "# Below are characters mapped x-sjis-softbank-auto, used in unicode -> encoding only\n";
    for my $row ( softbank_table() ) {
        next if !$row->{sjis_auto};
        printf "<U%s> %s |0 # SoftBank Pictogram\n", $row->{unicode},
          hexify( $row->{sjis_auto} );
    }
    print footer();
}

my $sjis_auto_map;
sub in_softbank_pictogram {
    my $sjis = shift;
    $sjis_auto_map ||= +{ map { (uc hexify($_->{sjis_auto})) => 1 } grep { $_->{sjis_auto} } softbank_table() };
    return $sjis_auto_map->{uc $sjis};
}

sub softbank_table {
    sort { hex( $a->{unicode} ) <=> hex( $b->{unicode} ) } @{
        YAML::LoadFile(
            file( $FindBin::Bin, '..', 'dat', 'softbank-table.yaml' )
        )
      };
}

sub hexify {
    local $_ = shift;
    s/(..)/\\x$1/g;
    $_;
}

sub header {
    return <<"...";
<code_set_name> "x-sjis-softbank-auto-raw"
<code_set_alias> "x-sjis-vodafone-auto-raw"
...
}

sub footer {
    return <<'...';
END CHARMAP
...
}
