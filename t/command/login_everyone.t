use utf8;
use strict;
use t::Util;
use Test::More tests => 2;
use Test::Time::At;

my $m = create_mock_object;

subtest "member create ok" => sub_at {
    plan tests => 6;

    record_count_ok $m, { member => 0 };

    my $ret = $m->run_command('login.everyone' => {
        id => 123,
        name => 'name',
        screen_name => 'mogefuga',
        profile_image_url_https => 'http://mogefuga',
    });

    is_deeply $ret, {
        member_id => 'mogefuga',
        member_name => 'name',
        profile_image_url => 'http://mogefuga',
    }, 'data ok';

    record_count_ok $m, { member => 1 };

    test_actionlog_ok $m, {
        id         => 1,
        circle_id  => undef,
        member_id  => 'mogefuga',
        message_id => 'ログインしました。 (method=everyone, member_id=mogefuga, serial=123, name=name)',
        parameters => '["ログインしました。","method","everyone","member_id","mogefuga","serial","123","name","name"]',
    };

    is_deeply $m->db->single('member')->get_columns, {
        id          => 123,
        member_id   => 'mogefuga',
        member_name => 'name',
        image_url   => 'http://mogefuga',
        created_at  => 1234567890,
    }, 'data ok';
} 1234567890;


subtest "member update ok" => sub_at {
    plan tests => 6;

    record_count_ok $m, { member => 1 };

    my $ret = $m->run_command('login.everyone' => {
        id => 123,
        name => 'name mark2',
        screen_name => 'mogefuga',
        profile_image_url_https => 'http://piyopiyo',
    });

    is_deeply $ret, {
        member_id => 'mogefuga',
        member_name => 'name',
        profile_image_url => 'http://piyopiyo',
    }, 'data ok';

    record_count_ok $m, { member => 1 };

    test_actionlog_ok $m, {
        id         => 1,
        circle_id  => undef,
        member_id  => 'mogefuga',
        message_id => 'ログインしました。 (method=everyone, member_id=mogefuga, serial=123, name=name mark2)',
        parameters => '["ログインしました。","method","everyone","member_id","mogefuga","serial","123","name","name mark2"]',
    };

    is_deeply $m->db->single('member')->get_columns, {
        id          => 123,
        member_id   => 'mogefuga',
        member_name => 'name',
        image_url   => 'http://piyopiyo',
        created_at  => 1234567890,
    }, 'data ok';
} 1234567890;
