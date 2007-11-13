#!/usr/bin/perl
use strict;
use warnings;
use Web::Scraper;
use URI;
use YAML;

my $emoji = scraper {
  process '//table[@width="100%" and @cellpadding="2"]//tr/td/font/../..',
    'emoji[]' => scraper {
      process '//td[2]/font', code => 'TEXT';
      process '//td[3]/font', char => 'TEXT';
    };
  result 'emoji';
};

my @urls = (
  'http://72.14.253.104/search?q=cache:http%3A//developers.softbankmobile.co.jp/dp/tool_dl/web/picword_01.php',
  'http://72.14.253.104/search?q=cache:http%3A//developers.softbankmobile.co.jp/dp/tool_dl/web/picword_02.php',
  'http://72.14.253.104/search?q=cache:http%3A//developers.softbankmobile.co.jp/dp/tool_dl/web/picword_03.php',
  'http://72.14.253.104/search?q=cache:http%3A//developers.softbankmobile.co.jp/dp/tool_dl/web/picword_04.php',
  'http://72.14.253.104/search?q=cache:http%3A//developers.softbankmobile.co.jp/dp/tool_dl/web/picword_05.php',
  'http://72.14.253.104/search?q=cache:http%3A//developers.softbankmobile.co.jp/dp/tool_dl/web/picword_06.php',
);
my $res;
foreach my $url (@urls) { push @$res, @{$emoji->scrape(URI->new($url))} };
print Dump $res;
