package InfoWSD::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use JSON::Syck;
use Data::Dumper;

use constant OK  => 1;
use constant NO  => 0;
use constant ON  => 1;
use constant OFF => 0;


any '/' => sub {
    my ($c) = @_;
    my @tests = $c->db->search('test', {}, { order_by => 'id asc' });
    $c->render('index.tt', { tests => \@tests });
};

any '/api/pc/' => sub {
    my ($c) = @_;
    my $pc_room_nows = $c->db->search('pc_room_now', {}, { order_by => 'id asc' });
    if ($c->req->param('fmt') eq 'json') {
        my %data;
        while (my $pc_room_now = $pc_room_nows->next) {
            $data{$pc_room_now->name} = +{
                status => $pc_room_now->status,
                usage_rate => $pc_room_now->usage_rate,
                capacity => $pc_room_now->capacity,
                class_name => $pc_room_now->class_name,
                extra => $pc_room_now->extra,
            };
        }
        my $json = JSON::Syck::Dump(\%data);
        $c->render('api/pc/default.json', { json => $json });
    }
    else {
        $c->render('api/pc/no_items.tt');
    }
};

any '/api/class/' => sub {
    my ($c) = @_;
    my $json;
    $c->render('api/class/default.json', { json => $json });
};

any '/api/test' => sub {
    my ($c) = @_;
    my $type = $c->req->param('type');
    my $t_data;
    if ($type eq 'pc') {
        $t_data = _make_pc_testdata();
    }
    elsif ($type eq 'class') {
        $t_data = _make_class_testdata();
    }
    else {
        $t_data = [{
            name => 'foo',
            type => 'test',
        }, {
            name => 'bar',
            type => 'hoge',
        }];
    }
    my $json = JSON::Syck::Dump($t_data);
    $c->render('api/test.json', { json => $json });
};

sub _make_pc_testdata {
    return  +{
        A => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        B => +{
            status => NO,
            usage_rate => 80,
            capacity => 80,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        C => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        D => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        E => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        F => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        G => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        H => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
        Z => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
    };
}

sub _make_class_testdata {
    return [{
        period => 1,
        building => 63,
        room => 304,
        lan => OK,
    }, {
        period => 3,
        building => 54,
        room => 102,
        lan => NO,
    }];
}


1;
