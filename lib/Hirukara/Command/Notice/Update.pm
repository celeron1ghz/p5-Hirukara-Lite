package Hirukara::Command::Notice::Update;
use Mouse;

with 'MouseX::Getopt', 'Hirukara::Command';

has key       => ( is => 'ro', isa => 'Str' );
has title     => ( is => 'ro', isa => 'Str', required => 1 );
has text      => ( is => 'ro', isa => 'Str', required => 1 );
has member_id => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self = shift;
    my $key  = $self->key || time;
    my $ret  = $self->database->insert(notice => {
        key       => $key,
        member_id => $self->member_id,
        title     => $self->title,
        text      => $self->text,
    }); 

    my $log_key = $self->key ? "NOTICE_UPDATE" : "NOTICE_CREATE";
    $self->action_log($log_key => [ id => $ret->id, key => $ret->key, member_id => $ret->member_id, title => $ret->title, text_length => length $ret->text ]);
    $ret;
}

1;
