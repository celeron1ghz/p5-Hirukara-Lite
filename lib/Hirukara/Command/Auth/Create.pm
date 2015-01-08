package Hirukara::Command::Auth::Create;
use Moose;

with 'MooseX::Getopt', 'Hirukara::Command';

has member_id => ( is => 'ro', isa => 'Str', required => 1 );
has role_type => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $cond = { member_id => $self->member_id, role_type => $self->role_type };

    if (my $auth = $self->database->single(member_role => $cond) )  {
        $self->action_log(AUTH_EXISTS => [  member_id => $auth->member_id, role => $auth->role_type ]);
        return;
    }

    my $ret = $self->database->insert(member_role => $cond);
    $self->action_log([ id => $ret->id, member_id => $ret->member_id, role => $ret->role_type ]);

    $ret;
}

1;
