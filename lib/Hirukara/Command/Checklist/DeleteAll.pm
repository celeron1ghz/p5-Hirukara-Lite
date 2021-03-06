package Hirukara::Command::Checklist::DeleteAll;
use utf8;
use Moose;

with 'MooseX::Getopt', 'Hirukara::Command';

has member_id  => ( is => 'ro', isa => 'Str', required => 1 );
has exhibition => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $ret = $self->db->delete(checklist => {
        member_id => $self->member_id,
        circle_id => \["IN (SELECT id FROM circle WHERE comiket_no = ?)", $self->exhibition],
    });
    $self->actioninfo("チェックリストを全削除しました。", member_id => $self->member_id, exhibition => $self->exhibition, count => $ret);
    $ret;
}

__PACKAGE__->meta->make_immutable;
