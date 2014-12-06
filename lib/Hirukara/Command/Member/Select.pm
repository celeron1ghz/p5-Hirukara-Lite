package Hirukara::Command::Member::Select;
use Mouse;
use Log::Minimal;

with 'MouseX::Getopt', 'Hirukara::Command';

has member_id => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $ret = $self->database->single(member => { member_id => $self->member_id });
    $ret;
}

1;