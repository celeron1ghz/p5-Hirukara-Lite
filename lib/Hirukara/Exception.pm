package Hirukara::Exception;
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
}

## circle
package Hirukara::Circle::CircleNotFoundException {
    use parent -norequire, 'Hirukara::Exception';
}

1;
