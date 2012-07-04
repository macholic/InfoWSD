#!/home/macholic/perl5/perlbrew/perls/perl-5.14.2/bin/perl

use strict;
use warnings;
use Encode;
use LWP::UserAgent;
use JSON::Syck;
use Data::Dumper::Concise;

my $url = 'http://macholic.digital-bot.com/api/test';

my $ua = LWP::UserAgent->new;
$ua->timeout(15);
my $res = $ua->get($url);
my $content = $res->content if $res && $res->is_success;
die unless $content;
my $data = JSON::Syck::Load($content);

print Dumper $data;
