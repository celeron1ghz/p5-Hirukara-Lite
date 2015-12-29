package Hirukara::Command::CircleOrder::Export::BuyPdf;
use utf8;
use Moose;
use Log::Minimal;

with 'MooseX::Getopt', 'Hirukara::Command', 'Hirukara::Command::CircleOrder::Exporter';

has where => ( is => 'ro', isa => 'Hash::MultiValue', required => 1 );

sub extension { 'pdf' }

sub run {
    my $self = shift;
    my($it,$cond) = $self->get_all_prefetched($self->where);
    $self->generate_pdf('pdf/buy.tt', { circles => [$it->all], label => $cond->{condition_label} });

    my $e = $self->hirukara->exhibition;
    infof "購買リストを出力しました。(exhibition=%s, run_by=%s, cond=%s)", $e, $self->run_by, ddf($self->where);
    $self;
}

1;
