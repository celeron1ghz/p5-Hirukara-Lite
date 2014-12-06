package Hirukara::Command::Assignlist::Single;
use Mouse;

with 'MouseX::Getopt', 'Hirukara::Command';

has id => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $ret = $self->database->single(assign_list => { id => $self->id });
    $ret;
}

1;
