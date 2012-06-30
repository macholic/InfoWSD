package InfoWSD::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use JSON::Syck;

any '/' => sub {
    my ($c) = @_;
    $c->render('index.tt');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    $c->redirect('/');
};

any '/api/test' => sub {
    my ($c) = @_;
    my $t_data = [
        {
            ROOM => "A",
            USING => 0,
        },
        {
            ROOM => "B",
            USING => 1,
        },
    ];
    my $json = JSON::Syck::Dump($t_data);
    $c->render('api/test.json', { json => $json });
};

1;
