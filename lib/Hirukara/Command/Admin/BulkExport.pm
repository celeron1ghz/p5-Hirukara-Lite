package Hirukara::Command::Admin::BulkExport;
use utf8;
use Moose;
use Hirukara::Parser::CSV;
use Hash::MultiValue;
use Path::Tiny;
use File::Temp 'tempdir';
use Archive::Zip;
use Encode;
use Parallel::ForkManager;

use Hirukara::Command::CircleOrder::Export::DistributePdf;
use Hirukara::Command::CircleOrder::Export::BuyPdf;
use Hirukara::Command::CircleOrder::Export::OrderPdf;
use Hirukara::Command::CircleOrder::Export::ComiketCsv;

with 'MooseX::Getopt', 'Hirukara::Command';

has run_by => ( is => 'ro', isa => 'Str', required => 1 );

sub run {
    my $self    = shift;
    my $e       = $self->hirukara->exhibition;
    my @lists   = $self->db->search('assign_list' => { comiket_no => $e })->all;
    my $tempdir = path(tempdir());
    my $start   = time;
    my @jobs;

    for my $member ($self->db->select('member')->all)   {
        push @jobs, {
            object => Hirukara::Command::CircleOrder::Export::OrderPdf->new(
                hirukara   => $self->hirukara,
                exhibition => $e,
                member_id  => $member->member_id,
                run_by     => $self->run_by,
            ),
            dest => $tempdir->path(sprintf "%s [ORDER].pdf", $member->member_id),
        };
    }

    for my $list (@lists)   {
        my $name      = $list->name;
        my $member_id = $list->member_id || 'NOT_ASSIGNED';

        for ($name, $member_id) {
            s!/!-!g;
            $_ = encode_utf8 $_;
        }

        push @jobs, {
            object => Hirukara::Command::CircleOrder::Export::BuyPdf->new(
                hirukara   => $self->hirukara,
                exhibition => $e,
                where      => Hash::MultiValue->new(assign => $list->id),
                run_by     => $self->run_by,
            ),
            dest => $tempdir->path(sprintf "%s (%s) [BUY].pdf", $name, $member_id),
        },{
            object => Hirukara::Command::CircleOrder::Export::DistributePdf->new(
                hirukara       => $self->hirukara,
                exhibition     => $e,
                assign_list_id => $list->id,
                run_by         => $self->run_by,
            ),
            dest => $tempdir->path(sprintf "%s (%s) [DISTRIBUTE].pdf", $name, $member_id),
        },{
            object => Hirukara::Command::CircleOrder::Export::ComiketCsv->new(
                hirukara   => $self->hirukara,
                exhibition => $e,
                where      => Hash::MultiValue->new(assign => $list->id),
                run_by     => $self->run_by,
            ),
            dest => $tempdir->path(sprintf "%s (%s).csv", $name, $member_id),
        };
    }

    $self->actioninfo("チェックリストの一括出力を行います。" => 
        exhibition => $e,
        list_count => scalar @jobs,
        run_by     => $self->run_by,
    );

    my $pm  = Parallel::ForkManager->new(8);
    my $zip = Archive::Zip->new;

    for my $j (@jobs)   {
        $pm->start and next;
        $j->{object}->run;
        $pm->finish;
    }

    $pm->wait_all_children;

    for my $j (@jobs)   {
        my $obj = $j->{object};
        my $tmp = path($obj->file);
        my $dst = $j->{dest};
        $tmp->move($dst);
        $zip->addFile("$dst", $dst->basename);
    }

    my $archive = File::Temp::tempnam(tempdir(), "hirukara");
    $zip->writeToFileNamed($archive);
    my $end = time;
    $self->actioninfo("チェックリストの一括出力を行いました。", => 
        exhibition => $e,
        list_count => scalar @jobs,
        run_by     => $self->run_by,
        elpased    => $end - $start
    );

    return $archive;
}

1;
