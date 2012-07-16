#!/home/macholic/perl5/perlbrew/perls/perl-5.14.2/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use Encode qw/decode encode/;
use DBI;
use Data::Dumper;
use lib qw(/home/macholic/project/InfoWSD/lib);
use InfoWSD;

my $url = 'http://www3.sci.waseda.ac.jp/tools/pcroom/pcroomstat.php';

my %pcroom_map = (
        '63号館 Aルーム' => 'A',
        '63号館 Bルーム' => 'B',
        '63号館 Cルーム' => 'C',
        '63号館 Dルーム' => 'D',
        '63号館 Eルーム' => 'E',
        '63号館 Fルーム' => 'F',
        '63号館 Gルーム' => 'G',
        '63号館 Hルーム' => 'H',
        '57号館 製図/CAD室' => 'Z'
);

sub http_request {

        my $url = $_[0];

        my $ua = LWP::UserAgent->new;
        my $req = HTTP::Request->new(GET=>$url);
        my $res = $ua->request($req);
        die unless $res && $res->is_success;
        my $body = encode('UTF-8', decode('EUC-JP', $res->content));

        my $tree = HTML::TreeBuilder->new;
        $tree->parse($body);

        return $tree;
}

my $tree = &http_request($url);
my @rooms = $tree->look_down('class', 'pcroom');

my $wsd = InfoWSD->new;
my @room_usages;

my $sequence = InfoWSD::DateTime->now->strftime("%Y%m%d%H%M%S");

foreach my $room (@rooms) {

    my $name = $room->as_text;
    my $status = 0;
    my $usage_rate = 0;
    my $capacity = 0;
    my $class = '';
    my $extra => '';

    # オープン中の場合
    if ($room->right()->as_text =~ 'オープン利用中') {
        $status = 1;

        my $s = $room->right()->right()->as_text;

        # 利用率
        if ($s =~ /利用率：([0-9]*)%/) {
                $usage_rate = $1;
        }

        # キャパシティ
        if ($s =~ /\([0-9]* \/ ([0-9]*)\)/) {
                $capacity = $1;
        }

    # 授業で使われている場合
    } else {
        $status = 0;

        # クラス
        $class = $room->right()->right()->as_text;
    }

    my %room_usage = (
        'sequence' => $sequence,
        'name' => $pcroom_map{$room->as_text},
        'status' => $status,
        'usage_rate' => $usage_rate,
        'capacity' => $capacity,
        'class_name' => $class,
        'extra' => $extra
    );

    push @room_usages, \%room_usage;
}

# update pc_room_log table
$wsd->db->bulk_insert('pc_room_log', \@room_usages);

#my $latest_sequence = $wsd->db->single('pc_room_log', {},  +{order_by => 'sequence desc'})->sequence;
#my $latest_rows = $wsd->db->search('pc_room_log', {sequence => $latest_sequence}, +{});

for my $room_usage (@room_usages) {
    delete($room_usage->{'sequence'});
}

# update pc_room_now table
$wsd->db->delete('pc_room_now');
$wsd->db->bulk_insert('pc_room_now', \@room_usages);
