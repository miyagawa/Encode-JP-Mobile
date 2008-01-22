use strict;

# http://labs.unoh.net/2007/02/post_65.html to dat/convert-map-utf8.yaml
# mkdir dat/conv; download emoji_*.txt to dat/conv/emoji_*.txt
# perl tools/make-convert-map.pl > dat/convert-map-utf8.yaml

use utf8;
use Encode;
use Encode::JP::Mobile 0.09;
use File::Slurp qw(slurp);
use YAML;

my $no2uni = {};
for my $file (qw( emoji_e2is.txt emoji_i2es.txt emoji_s2ie.txt )) {
    my @line = slurp "dat/conv/$file";
    for my $line (@line) {
        next unless $line =~ /^%/;
        my ($no, $byte) = split "\t", $line;
        
        $file eq 'emoji_i2es.txt' && do {
            $no2uni->{$no} = sprintf '%04X', ord decode('x-sjis-docomo', pack 'H*', $byte);
        };
        
        $file eq 'emoji_e2is.txt' && do {
            $no2uni->{$no} = sprintf '%04X', ord decode('x-sjis-kddi-auto', pack 'H*', $byte);
        };
        
        $file eq 'emoji_s2ie.txt' && do {
            $no2uni->{$no} = sprintf '%04X', ord decode('x-sjis-softbank', "\x1b\x24$byte\x0f");
        };
    }
}

my %map;
for my $file (qw( emoji_e2is.txt emoji_i2es.txt emoji_s2ie.txt )) {
    my @line = slurp "dat/conv/$file";
    
    for my $line (@line) {
        next unless $line =~ /^%/;
        chomp $line;

        $file eq 'emoji_i2es.txt' && do {
            my ($docomo, undef, $kddi, $softbank) = split "\t", $line;
            $map{docomo}{ $no2uni->{$docomo} }->{kddi}     = get_unicode($kddi);
            $map{docomo}{ $no2uni->{$docomo} }->{softbank} = get_unicode($softbank);
        };
        
        $file eq 'emoji_e2is.txt' && do {
            my ($kddi, undef, $docomo, $softbank) = split "\t", $line;
            $map{kddi}{ $no2uni->{$kddi} }->{docomo}   = get_unicode($docomo);
            $map{kddi}{ $no2uni->{$kddi} }->{softbank} = get_unicode($softbank);
        };
        
        $file eq 'emoji_s2ie.txt' && do {
            my ($softbank, undef, $docomo, $kddi) = split "\t", $line;
            $map{softbank}{ $no2uni->{$softbank} }->{docomo} = get_unicode($docomo);
            $map{softbank}{ $no2uni->{$softbank} }->{kddi}   = get_unicode($kddi);
        };
    }
}

sub get_unicode($) {
    my $key = shift;
    if ($key =~ /^%/) {
        $key =~ s/(%[^%]+%)/$no2uni->{$1}/ge;
        return $key;
    } else {
        return;
    }
}

print YAML::Dump \%map;
