package InfoWSD::DB::Row::Test;
use strict;
use warnings;
use utf8;
use parent qw(Teng::Row);
use InfoWSD::DateTime;

sub id_with_body {
    my $self = shift;
    my $text = sprintf("%s: %s", $self->id, $self->body);
    return $text;
}

1;

__END__
