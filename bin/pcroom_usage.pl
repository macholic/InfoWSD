#!/home/macholic/perl5/perlbrew/perls/perl-5.14.2/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use Encode qw/decode/;
use Encode qw/encode/;

my $url = 'http://www3.sci.waseda.ac.jp/tools/pcroom/pcroomstat.php';

my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET=>$url);
my $res = $ua->request($req);
my $body = encode('UTF-8', decode('EUC-JP', $res->content));

my $tree = HTML::TreeBuilder->new;
$tree->parse($body);

my @pcrooms = $tree->look_down('class', 'pcroom');
foreach my $room (@pcrooms) {
    print $room->as_text.": ";
    print $room->right()->as_text."\n";
}
