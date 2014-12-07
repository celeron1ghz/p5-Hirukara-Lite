package Hirukara::Command::Circle::Single;
use Mouse;

with 'MouseX::Getopt', 'Hirukara::Command';

has circle_id => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $ret = $self->database->single(circle => { id => $self->circle_id });
    $ret;
}

1;