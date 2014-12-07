package Hirukara::Command::Assignlist::Update;
use Mouse;
use Log::Minimal;

with 'MouseX::Getopt', 'Hirukara::Command';

has assign_id        => ( is => 'ro', isa => 'Str', required => 1);
has member_id        => ( is => 'ro', isa => 'Str', required => 1);
has assign_member_id => ( is => 'ro', isa => 'Str', required => 1);
has assign_name      => ( is => 'ro', isa => 'Str', required => 1);

sub run {
    my $self = shift;
    my $id            = $self->assign_id;
    my $member_id     = $self->member_id;
    my $assign_member = $self->assign_member_id;
    my $assign_name   = $self->assign_name;
    my $assign        = $self->database->single(assign_list => { id => $id });

    if ($assign_member ne $assign->member_id) {
        my $before_assign_member = $assign->member_id;
        $assign->member_id($assign_member);
        infof "UPDATE_ASSIGN_MEMBER: assign_id=%s, updated_by=%s, before_member=%s, updated_name=%s", $assign->id, $member_id, $before_assign_member, $assign_member;

=for

        $self->__create_action_log(ASSIGN_MEMBER_UPDATE => {
            updated_by     => $member_id,
            assign_id      => $assign->id,
            before_member  => $before_assign_member,
            updated_member => $assign_member,
        });

=cut

    }
    
    if ($assign_name ne $assign->name)   {
        my $before_name = $assign->name;
        $assign->name($assign_name);
        infof "UPDATE_ASSIGN_NAME: assign_id=%s, updated_by=%s, before_name=%s, updated_name=%s", $assign->id, $member_id, $before_name, $assign_name;

=for

        $self->__create_action_log(ASSIGN_NAME_UPDATE => {
            updated_by   => $member_id,
            assign_id    => $assign->id,
            before_name  => $before_name,
            updated_name => $assign_name,
        });
=cut

    }

    $assign->update if $assign->is_changed;
}

1;