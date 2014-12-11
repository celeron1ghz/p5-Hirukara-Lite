use utf8;
use strict;
use t::Util;
use Test::More tests => 7;
use Test::Exception;
use_ok 'Hirukara::Command::Actionlog::Select';
use_ok 'Hirukara::Command::Actionlog::Create';

my $m = create_mock_object;

subtest "actionlog invalid args" => sub {
    throws_ok {
        Hirukara::Command::Actionlog::Create->new(database => $m->database, message_id => "moge", parameters => {})->run;
    } qr/actionlog message=moge not found/, 'die on message id not exist';

    throws_ok {
        Hirukara::Command::Actionlog::Create->new(database => $m->database, message_id => "MEMBER_CREATE", parameters => {})->run;
    } qr/key 'member_id' is not exist in args 'parameter'/, 'die on not enough parameter';
};


subtest "actionlog create ok" => sub {
    ok my $log = Hirukara::Command::Actionlog::Create->new(database => $m->database, message_id => "MEMBER_CREATE", parameters => { member_id => 'moge' })->run;
    is $log->id,         1,               "id ok";
    is $log->message_id, "MEMBER_CREATE", "message_id ok";
    is $log->parameters, '{"member_id":"moge"}', "parameters ok";
    ok !$log->circle_id, "circle_id ok";
};


supress_log {
    Hirukara::Command::Actionlog::Create->new(database => $m->database, message_id => "MEMBER_CREATE", parameters => { member_id => $_ })->run for 2 .. 128;
};


subtest "all rows return on specify count=0" => sub {
    my $ret = Hirukara::Command::Actionlog::Select->new(database => $m->database, count => 0)->run;
    is scalar @$ret, 128, "return count ok";
};


subtest "single actionlog test" => sub {
    my $ret = Hirukara::Command::Actionlog::Select->new(database => $m->database, count => 1)->run;
    is scalar @$ret, 1, "return count ok";
    is_deeply $ret, [{ message => '128 さんが初めてログインしました', type => 'メンバーの新規ログイン' }], "data ok";
};


subtest "getting specify count actionlog test" => sub {
    my $ret = Hirukara::Command::Actionlog::Select->new(database => $m->database, count => 20)->run;
    is scalar @$ret, 20, "return count ok";
};