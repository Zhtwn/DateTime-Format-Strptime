package DateTime::Format::Strptime::Types;

use strict;
use warnings;

our $VERSION = '1.71';

use parent 'Specio::Exporter';

use DateTime::Locale::Base;
use DateTime::TimeZone;
use Specio 0.18;
use Specio::Declare;
use Specio::Library::Builtins -reexport;
use Specio::Library::String -reexport;

union(
    'Locale',
    of => [
        object_isa_type('DateTime::Locale::Base'),
        object_isa_type('DateTime::Locale::FromData'),
    ],
);

coerce(
    t('Locale'),
    from   => t('NonEmptyStr'),
    inline => sub {"DateTime::Locale->load( $_[1] )"},
);

object_isa_type( 'TimeZone', class => 'DateTime::TimeZone' );

coerce(
    t('TimeZone'),
    from   => t('NonEmptyStr'),
    inline => sub {"DateTime::TimeZone->new( name => $_[1] )"},
);

union(
    'OnError',
    of => [
        enum( values => [ 'croak', 'undef' ] ),
        t('CodeRef'),
    ],
);

1;

# ABSTRACT: Types used for parameter checking in DateTime::Format::Strptime

__END__

=pod

=for Pod::Coverage .*

=head1 DESCRIPTION

This module has no user-facing parts.

=cut