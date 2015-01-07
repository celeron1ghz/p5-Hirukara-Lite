use strict;
use Test::More;
eval {
    require Test::Perl::Critic;
    Test::Perl::Critic->import(-severity => 4, -profile => 'xt/perlcriticrc', -verbose => 0);
};
plan skip_all => "Test::Perl::Critic is not installed." if $@;
all_critic_ok('lib');
