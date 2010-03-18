use strict;
use warnings;

use Test::More;

eval { require Test::Kwalitee; Test::Kwalitee->import() };
plan skip_all => "Test::Kwalitee needed for testing kwalitee"
    if $@;