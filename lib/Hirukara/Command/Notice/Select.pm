package Hirukara::Command::Notice::Select;
use Mouse;
use Log::Minimal;

with 'MouseX::Getopt', 'Hirukara::Command';

sub run {
    my $self = shift;
    $self->database->single('notice' => { id => \'= (SELECT MAX(id) FROM notice)' });
}

1;