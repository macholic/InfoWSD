package InfoWSD::DB;
use strict;
use warnings;
use utf8;
use parent qw(Teng);
use InfoWSD::DateTime;

__PACKAGE__->load_plugin('Pager');

sub _before_insert {
    my $self = shift;
    my ($table, $args) = @_;
    if ($table eq 'test') {
        $args->{body} = sprintf("%s_%s",
                                $args->{body},
                                InfoWSD::DateTime->now->strftime("%T"));
    }
    return;
}

sub insert {
    my $self = shift;
    $self->_before_insert(@_);
    return $self->SUPER::insert(@_);
}

sub fast_insert {
    my $self = shift;
    $self->_before_insert(@_);
    return $self->SUPER::fast_insert(@_);
}

1;
