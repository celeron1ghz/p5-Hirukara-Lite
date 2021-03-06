package Hirukara::Exception;
use utf8;
use strict;
use warnings;
use parent 'Exception::Tiny';

## cli
package Hirukara::CLI::ClassLoadFailException {
    use parent -norequire, 'Hirukara::Exception';
}

## checklist
package Hirukara::Checklist::ChecklistNotUploadedException {
    use parent -norequire, 'Hirukara::Exception';

    sub message { "チェックリストをアップロードしてください。" }
}

package Hirukara::Checklist::NotAComiketException {
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['exhibition'];

    sub message {
        my $self = shift;
        sprintf "現在受け付けている '%s' はコミケットではないのでこの操作は実行出来ません。", $self->exhibition;
    }
}

package Hirukara::Checklist::ParseException {
    use parent -norequire, 'Hirukara::Exception';
}

package Hirukara::Checklist::InvalidExportTypeException {
    use parent -norequire, 'Hirukara::Exception';
}

package Hirukara::Checklist::NoSuchCircleInListException {
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['list'];

    sub message {
        my $self = shift;
        sprintf "出力しようとしたリストにはサークルが存在しません。(%s)", $self->list;
    }
}

package Hirukara::CSV::NotActiveComiketChecklistUploadedException {
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['want_exhibition', 'given_exhibition'];

    sub message {
        my $self = shift;
        sprintf "現在受け付けているのは '%s' ですが、アップロードされたCSVファイルは '%s' のCSVです。", $self->want_exhibition, $self->given_exhibition; 
    }
}

package Hirukara::Assign::ListConditionNotMatchException {
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['assign_list', 'circle'];

    sub message {
        my $self = shift;
        my $list = $self->assign_list;
        my $c    = $self->circle;
        sprintf "割当リスト '%s' は %s %s日目のリストですが、割り当てようとしたしたサークル '%s' は %s %s日目です。"
            , $list->name, $list->comiket_no, $list->day, $c->circle_name, $c->comiket_no, $c->day;
    }
}

## general
package Hirukara::RuntimeException {
    use utf8;
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['cause'];
    sub message { '想定外のエラーが発生しました。そのうちなんとかします。お急ぎの方は管理者まで連絡ください。' }
}

package Hirukara::ValidateException {
    use utf8;
    use parent -norequire, 'Hirukara::Exception';
}

package Hirukara::DB::MemberNotInDatabaseException {
    use utf8;
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['member_id'];
    sub message {
        my $self = shift;
        sprintf "ﾎﾟﾎﾟﾛﾝｽﾞﾇ...ﾎﾟﾎﾟﾛﾝｽﾞﾇ...(mid=%s)", $self->member_id;
    }
}

package Hirukara::DB::NoSuchRecordException {
    use utf8;
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['table', 'id', 'member_id'];
    sub message {
        my $self = shift;
        sprintf "データが存在しません。(table=%s, id=%s, mid=%s)", $self->table, $self->id, $self->member_id;
    }
}

package Hirukara::DB::AssignStillExistsException {
    use utf8;
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['assign_list'];
    sub message {
        my $self = shift;
        my $l = $self->assign_list;
        sprintf "割り当てリスト '%s' はまだ割り当てが存在します。割り当ての削除を行う際は全ての割り当てを削除してから行ってください。(aid=%s)"
            , $l->name, $l->id;
    }
}

package Hirukara::DB::CircleOrderRecordsStillExistsException {
    use utf8;
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['book'];
    sub message {
        my $self = shift;
        my $b = $self->book;
        my $c = $b->circle;
        sprintf "サークル '%s' の本 '%s' はまだ発注している人がいます。本の削除を行う際は全ての発注を削除してから行ってください。(cid=%s, bid=%s)"
            , $c->circle_name, $b->book_name, $c->id, $b->id;
    }
}

1;
