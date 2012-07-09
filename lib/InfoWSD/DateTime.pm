package InfoWSD::DateTime;
use strict;
use warnings;
use parent qw(DateTime);

our $DEFAULT_TIMEZONE = DateTime::TimeZone->new(name => 'local');

sub new {
    my ($class, %opts) = @_;
    $opts{time_zone} ||= $DEFAULT_TIMEZONE;
    return $class->SUPER::new(%opts);
}

sub now {
    my ($class, %opts) = @_;
    $opts{time_zone} ||= $DEFAULT_TIMEZONE;
    return $class->SUPER::now(%opts);
}

1;

__END__
