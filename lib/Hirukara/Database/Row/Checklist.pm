package Hirukara::Database::Row::Checklist;
use utf8;
use 5.014002;
use Mouse v2.4.5;
use Hirukara::Constants::Area;
extends qw/Hirukara::Database::Row/;

use Class::Accessor::Lite (
    new => 0,
    rw => [ qw/member/ ],
);

1;
