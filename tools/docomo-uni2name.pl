#!/usr/bin/perl
use strict;
use warnings;
use HTML::Selector::XPath 0.03;
use Web::Scraper;
use URI;
use YAML;

my $uri = URI->new(
    "http://www.nttdocomo.co.jp/service/imode/make/content/pictograph/basic/index.html"
);
my $scraper = scraper {
    process 'tr', 'hoge[]', scraper {
        process 'td:nth-child(5)', 'unicode', 'TEXT';
        process 'td:nth-child(6)', 'jpname',  'TEXT';
    };
};
my $result = $scraper->scrape($uri);
print Dump($result);
