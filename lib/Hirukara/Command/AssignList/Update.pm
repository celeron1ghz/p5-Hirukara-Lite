package Hirukara::Command::AssignList::Update;
use utf8;
use Moose;

with 'MooseX::Getopt', 'Hirukara::Command';

has assign_id        => ( is => 'ro', isa => 'Str', required => 1);
has member_id        => ( is => 'ro', isa => 'Str', required => 1);
has assign_member_id => ( is => 'ro', isa => 'Str', required => 1);
has assign_name      => ( is => 'ro', isa => 'Str', required => 1);

sub run {
    my $self = shift;
    my $id            = $self->assign_id;
    my $member_id     = $self->member_id;
    my $assign_member = $self->assign_member_id || '';
    my $assign_name   = $self->assign_name      || '';
    my $assign        = $self->db->single(assign_list => { id => $id });
    my $updated_value = {};
    my $before_assign_member = $assign->member_id || '';

    if ($assign_member ne $before_assign_member) {
        $updated_value->{member_id} = $assign_member;

        $self->actioninfo('割り当てリストのメンバーを更新しました。' =>
            id            => $assign->id,
            member_id     => $member_id,
            before_member => $before_assign_member,
            after_member  => $assign_member,
        );
    }
    
    if ($assign_name ne $assign->name)   {
        my $before_name = $assign->name || '';
        $updated_value->{name} = $assign_name;

        $self->actioninfo('割り当てリストのリスト名を更新しました。' =>
            id          => $assign->id,
            member_id   => $member_id,
            before_name => $before_name,
            after_name  => $assign_name,
        );
    }

    $self->db->update($assign, $updated_value) if keys %$updated_value;
}

1;
