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
    my @test = $c->db->search('test', {}, { order_by => 'id desc' });
    $c->render('index.tt', { test => \@test });
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    $c->redirect('/');
};

any '/api/test' => sub {
    my ($c) = @_;
    my $t_data;
    $t_data = +{
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
        CAD => +{
            status => OK,
            usage_rate => 66,
            capacity => 101,
            class => "test",
            extra => +{
                test => ON,
            },
        },
    };
    my $json = JSON::Syck::Dump($t_data);
    $c->render('api/test.json', { json => $json });
};

1;
