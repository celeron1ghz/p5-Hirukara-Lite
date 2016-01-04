package Hirukara::Command::Member::Select;
use Moose;

with 'MooseX::Getopt', 'Hirukara::Command';

has member_id => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $ret = $self->db->single(member => { member_id => $self->member_id });
    $ret;
}

__PACKAGE__->meta->make_immutable;
