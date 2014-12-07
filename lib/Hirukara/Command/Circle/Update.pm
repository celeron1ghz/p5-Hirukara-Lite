package Hirukara::Command::Circle::Update;
use Mouse;
use Log::Minimal;

with 'MouseX::Getopt', 'Hirukara::Command';

has member_id   => ( is => 'ro', isa => 'Str', required => 1 );
has circle_id   => ( is => 'ro', isa => 'Str', required => 1 );
has circle_type => ( is => 'ro', isa => 'Str', default => '' );
has comment     => ( is => 'ro', isa => 'Str', default => '' );

sub run {
    my $self = shift;
    my $circle = $self->database->single(circle => { id => $self->circle_id }) or return;

    my $circle_id = $self->circle_id;
    my $member_id = $self->member_id;
    my $comment   = $self->comment;

    if ($self->circle_type && $self->circle_type ne ($circle->circle_type || ''))    {   
        my $before_circle_type = $circle->circle_type;
        my $after_circle_type  = $self->circle_type;

        $circle->circle_type($after_circle_type);

        infof "UPDATE_CIRCLE_TYPE: circle_id=%s, before=%s, after=%s", $circle_id, $before_circle_type, $after_circle_type;

        my $before = Hirukara::Constants::CircleType::lookup($before_circle_type);
        my $after  = Hirukara::Constants::CircleType::lookup($after_circle_type);

=for

        $self->__create_action_log(CIRCLE_TYPE_UPDATE => {
            circle_id   => $circle->id,
            circle_name => $circle->circle_name,
            member_id   => $member_id,
            before_type => $before->{label},
            after_type  => $after->{label},
        });

=cut

    }   

    if ($comment && $comment ne ($circle->comment || ''))   {   
        $circle->comment($comment);

        infof "UPDATE_CIRCLE_COMMENT: circle_id=%s", $circle_id;

=for

        $self->__create_action_log(CIRCLE_COMMENT_UPDATE => {
            circle_id   => $circle->id,
            circle_name => $circle->circle_name,
            member_id   => $member_id,
        });

=cut

    }

    if ($circle->is_changed)    {
        $circle->update;
        return $circle;
    }
    else {
        return;
    }
}

1;