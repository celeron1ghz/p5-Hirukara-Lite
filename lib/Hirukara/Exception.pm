package Hirukara::Exception;
use utf8;
use strict;
use warnings;
use parent 'Exception::Tiny';

## cli
package Hirukara::CLI::ClassLoadFailException {
    use parent -norequire, 'Hirukara::Exception';
}

## csv
package Hirukara::CSV::Header::HeaderNumberIsWrongException {
    use parent -norequire, 'Hirukara::Exception';
}

package Hirukara::CSV::Header::InvalidHeaderException {
    use parent -norequire, 'Hirukara::Exception';
}

package Hirukara::CSV::Header::UnknownCharacterEncodingException {
    use parent -norequire, 'Hirukara::Exception';
}

package Hirukara::CSV::ExhibitionNotMatchException {
    use parent -norequire, 'Hirukara::Exception';
    use Class::Accessor::Lite ro => ['want_exhibition', 'given_exhibition'];

    sub message {
        my $self = shift;
        sprintf "アップロードされたCSVファイルは'%s'のCSVですが、現在受け付けているのは'%s'のCSVです。", $self->given_exhibition, $self->want_exhibition; 
    }
}

## circle
package Hirukara::Circle::CircleNotFoundException {
    use parent -norequire, 'Hirukara::Exception';
}

1;