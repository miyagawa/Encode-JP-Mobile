use strict;
use utf8;
use Test::More 'no_plan';
use Encode;
use Encode::JP::Mobile;

my @map = (
    { name => 'hare',  imode => "\xF8\x9F", ezweb => "\xF6\x60" },
    { name => 'taifu', imode => "\xF8\xA4", ezweb => "\xF6\x41" },
    { name => 'ramen', imode => "\xF9\xF1", ezweb => "\xF7\xD1" },
);

for my $pict (@map) {
    is encode('shift_jis-ezweb', decode('shift_jis-imode', $pict->{imode}))
        => $pict->{ezweb}, 
        "imode => ezweb ($pict->{name})";
    
    is encode('shift_jis-imode', decode('shift_jis-imode', $pict->{imode}))
        => $pict->{imode}, 
        "imode => imode ($pict->{name})";
    
    is encode('shift_jis-imode', decode('shift_jis-ezweb', $pict->{ezweb}))
        => $pict->{imode}, 
        "ezweb => imode ($pict->{name})";
    
    is encode('shift_jis-ezweb', decode('shift_jis-ezweb', $pict->{ezweb}))
        => $pict->{ezweb}, 
        "ezweb => ezweb ($pict->{name})";
}


