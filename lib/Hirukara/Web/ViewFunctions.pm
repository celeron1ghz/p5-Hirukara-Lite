package Hirukara::Web::ViewFunctions;
use strict;
use warnings;
use utf8;
use parent qw(Exporter);
use Module::Functions;
use File::Spec;

use Time::Piece;

our @EXPORT = get_public_functions();

sub commify {
    local $_  = shift;
    1 while s/((?:\A|[^.0-9])[-+]?\d+)(\d{3})/$1,$2/s;
    return $_;
}

sub c           { Hirukara->context() }
sub uri_with    { Hirukara->context()->req->uri_with(@_) }
sub uri_for     { Hirukara->context()->uri_for(@_) }

sub f   {
    my $val = shift;
    $val =~ /^\d+$/
        ? Time::Piece->new($val)->strftime('%Y/%m/%d %H:%M:%S')
        : $val
}

{
    my %static_file_cache;
    sub static_file {
        my $fname = shift;
        my $c = Hirukara->context;
        if (not exists $static_file_cache{$fname}) {
            my $fullpath = File::Spec->catfile($c->base_dir(), $fname);
            $static_file_cache{$fname} = (stat $fullpath)[9];
        }
        return $c->uri_for(
            $fname, {
                't' => $static_file_cache{$fname} || 0
            }
        );
    }
}

1;
