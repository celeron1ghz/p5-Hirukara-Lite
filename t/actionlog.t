use strict;
use utf8;
use Hirukara::Actionlog;
use Test::More tests => 4;
use Test::Exception;
use Plack::Util;

sub object {
    my $param = shift;
    my $obj = {};

    while ( my($k,$v) = each %$param )  {
        $obj->{$k} = sub { $v };
    }

    return Plack::Util::inline_object(%$obj);
}

sub test_log {
    my($args,$expected) = @_;
    my $obj = object($args);
    my $got = Hirukara::Actionlog->extract_log($obj);
    is_deeply $got, $expected, "log extract ok";
}

throws_ok { Hirukara::Actionlog->extract_log } qr/log object not specified/, "die on no args";

throws_ok { Hirukara::Actionlog->extract_log( object({ message_id => 'aaaaaa' }) ) } qr/unknown message id 'aaaaaa'/, "die on no message";

test_log { id => 123, message_id => 'CHECKLIST_CREATE', parameters => '{"member_id":1234}', created_at => "mogefuga" }
        => { id => 123, message => "1234 さんが '' を追加しました", type => "チェックの追加", created_at => "mogefuga" };

test_log { id => 456, message_id => 'CHECKLIST_CREATE', parameters => '{"member_id":1234,"circle_name":5678}', created_at => "piyopiyo" }
        => { id => 456, message => "1234 さんが '5678' を追加しました", type => "チェックの追加", created_at => "piyopiyo" };
