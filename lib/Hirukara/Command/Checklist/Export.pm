package Hirukara::Command::Checklist::Export;
use Moose;
use File::Temp;
use Encode;
use JSON;
use Time::Piece; ## using in template
use Hirukara::Parser::CSV;
use Hirukara::SearchCondition;
use Hirukara::Command::Checklist::Joined;
use Log::Minimal;
use Text::Xslate;

with 'MooseX::Getopt', 'Hirukara::Command', 'Hirukara::Command::Exhibition';

has file => ( is => 'ro', isa => 'File::Temp', default => sub { File::Temp->new } );

has type         => ( is => 'ro', isa => 'Str', required => 1 );
has where        => ( is => 'ro', isa => 'Hash::MultiValue', required => 1 );
has template_var => ( is => 'ro', isa => 'HashRef', required => 1 );
has member_id    => ( is => 'ro', isa => 'Str', required => 1 );

sub __generate_pdf  {
    my($self,$template,$converted) = @_;
    my $xslate = Text::Xslate->new(
        path => './tmpl/',
        syntax => 'TTerse',
        function => {
            time => sub { Time::Piece->new },
            sprintf => \&CORE::sprintf,
        },
    );

    ## wkhtmltopdf don't read file unless file extension is '.html'
    my $html = File::Temp->new(SUFFIX => '.html');
    my $pdf  = $self->file;
    close $pdf;

    print $html encode_utf8 $xslate->render($template, { checklists => $converted, %{$self->template_var} });
    close $html;

    system "wkhtmltopdf", "--quiet", $html->filename, $pdf->filename;
}
 

my %TYPES = (
    checklist  => {
        template   => 'pdf/simple.tt',
        extension => 'csv',
        generator  => sub {
            my($self,$converted) = @_;
            my @ret = (
                sprintf("Header,ComicMarketCD-ROMCatalog,ComicMarket87,UTF-8,Windows 1.86.1"),
            );

            for my $circle (@$converted) {
                my $raw = decode_json $circle->serialized;
                my $row = Hirukara::Parser::CSV::Row->new($raw);
                my $fav = $circle->checklists;
                my @comment;
                my $cnt = 0;

                for my $f (@$fav)   {
                    $cnt += ($f->count || 0);

                    if ($f->comment)    {
                        push @comment, sprintf "%s=[%s]", $f->member->member_name, $f->comment;
                    }
                }

                my $remark = $circle->comment ? sprintf("[%s] ", $circle->comment) : "";
                my $comment = sprintf "%s%d冊 / %s", $remark, $cnt, join(", " => @comment);
                $comment =~ s/[\r\n]/  /g;

                $row->color(1);
                $row->comment(qq/"$comment"/);
                $row->remark(sprintf q/"%s"/, $row->remark);
                push @ret, encode_utf8 $row->as_csv_column;
            }

            my $file = $self->file;
            print {$file} join "\n", @ret;
            close $file;
        },
        
    },

    pdf_simple => {
        extension => 'pdf',
        generator => sub {
            my($self,$checklist) = @_;
            $self->__generate_pdf('pdf/simple.tt', $checklist);
        },
    },

    pdf_order  => {
        extension => 'pdf',
        generator => sub {
            my($self,$checklist) = @_;
            my %orders;
    
            for my $data (@$checklist) {
                my $checklists = $data->checklists;
    
                for my $chk (@$checklists)    {   
                    $orders{$chk->member_id}->{member} = $chk->member; 
                    push @{$orders{$chk->member_id}->{rows}}, $data;
                }   
            } 
    
            $self->__generate_pdf('pdf/order.tt', \%orders);
        },
    },

    pdf_assign => {
        extension => 'pdf',
        generator => sub {
            my($self,$checklist) = @_;
            my %assigns;

            for my $data (@$checklist) {
                my $assign = $data->assigns;
    
                for my $a (@$assign)    {
                    $assigns{$a->id}->{assign} = $a;
                    push @{$assigns{$a->id}->{rows}}, $data;
                }
            }
    
            $self->__generate_pdf('pdf/assign.tt', \%assigns);
        },
    },
);

sub run {
    my $self = shift;
    my $t    = $self->type;
    my $type = $TYPES{$t} or die "No such type '$t'";
    my $cond = Hirukara::SearchCondition->new(database => $self->database)->run($self->where);
    $self->template_var->{title} = $cond->{condition_label};

    my $checklist = Hirukara::Command::Checklist::Joined->new(
        database   => $self->database,
        exhibition => $self->exhibition,
        where      => $cond->{condition},
    )->run;

    my $tmpl = $type->{template};
    my $meth = $type->{generator};
    my $ext  = $type->{extension};
    $meth->($self,$checklist);

    infof "CHECKLIST_EXPORT: type=%s, member_id=%s, cond=%s"
        ,$t
        ,$self->member_id
        ,ddf($self->where);

    {
        exhibition => $self->exhibition,
        extension  => $ext,
        file       => $self->file,
    };
}

1;
