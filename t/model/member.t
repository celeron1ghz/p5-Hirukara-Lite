use strict;
use t::Util;
use Test::More tests => 9;
use Test::Exception;
use Hirukara::Model::Member;

my $h = create_model_mock('Hirukara::Model::Member');

## $self->get_member_by_id
throws_ok { $h->get_member_by_id } qr/missing mandatory parameter named '\$id'/, "die on no args";
throws_ok { $h->get_member_by_id(id => undef) } qr/'id': Validation failed for 'Str' with value undef/, "die on no args";
throws_ok { $h->get_member_by_id(id => [])    } qr/'id': Validation failed for 'Str' with value ARRAY/, "die on no args";
ok !$h->get_member_by_id(id => "mogefuga"), "object not returned";


## $self->create_member
my $out = capture_merged { $h->create_member(id => "112233", member_id => "fugafuga", image_url => "image") };
ok my $m1 = $h->get_member_by_id(id => "112233"), "object return ok";
is $m1->id,        "112233",   "created member";
is $m1->member_id, "fugafuga", "created member";
is $m1->image_url, "image",    "created member";
like $out, qr/\[INFO\] CREATE_MEMBER: id=112233, member_id=fugafuga/, 'log output ok';