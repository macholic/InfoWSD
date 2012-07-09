#!/home/macholic/perl5/perlbrew/perls/perl-5.14.2/bin/perl

use strict;
use warnings;
use lib qw(/home/macholic/project/InfoWSD/lib);

use InfoWSD;
use Data::Dumper;

my $db = InfoWSD->new->db;
my $tests = $db->search('test', +{
    id => +{ in => [qw/1 2 4 5/] },
    }, +{
    order_by => 'id asc' }
);
while (my $test = $tests->next) {
    print $test->id_body_as_text , "\n";
}

$db->insert(
    'test' => {
        body => "from script",
    }
);
