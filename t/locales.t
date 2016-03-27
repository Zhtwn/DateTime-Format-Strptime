use strict;
use warnings;

use Test::More 0.96;
use Test::Fatal;

use DateTime::Format::Strptime;
use DateTime::Locale;
use DateTime;

my @locales
    = $ENV{AUTHOR_TESTING}
    ? ( sort DateTime::Locale->ids )
    : qw( en de ga pt zh );

my $code_meth = DateTime::Locale->load('en')->can('code') ? 'code' : 'id';

binmode $_, ':encoding(UTF-8)'
    for map { Test::Builder->new->$_ }
    qw( output failure_output todo_output );

foreach my $locale (@locales) {
    subtest(
        $locale,
        sub {
            test_days($locale);
            test_months($locale);
            test_am_pm($locale);
            test_locale($locale);
        }
    );
}

subtest(
    'format_datetime with locale',
    sub {
        my $strptime = DateTime::Format::Strptime->new(
            pattern  => '%B %Y',
            locale   => 'pt',
            on_error => 'croak',
        );

        my $dt = DateTime->new(
            year   => 2015,
            month  => 8,
            locale => 'en',
        );

        is(
            $strptime->format_datetime($dt),
            'agosto 2015',
            'formatted output is in locale of formatter (Portugese)'
        );

        is(
            $dt->locale->$code_meth,
            'en',
            q{formatter leaves DateTime object's locale unchanged}
        );
    }
);

done_testing();

sub test_days {
    my $locale = shift;

    subtest(
        'days',
        sub {
            foreach my $day ( 1 .. 7 ) {
                subtest(
                    "Day $day",
                    sub { _test_one_day( $locale, $day ); },
                );
            }
        }
    );
}

sub _test_one_day {
    my $locale = shift;
    my $day    = shift;

    my $pattern = '%Y-%m-%d %A';

    my $dt = DateTime->now( locale => $locale )->set( day => $day );
    my $input = $dt->strftime($pattern);

    my $strptime;
    is(
        exception {
            $strptime = DateTime::Format::Strptime->new(
                pattern  => $pattern,
                locale   => $locale,
                on_error => 'croak',
            );
        },
        undef,
        'constructor with day name in pattern (%A)'
    ) or return;

    my $parsed_dt;
    is(
        exception {
            $parsed_dt = $strptime->parse_datetime($input)
        },
        undef,
        "parsed $input"
    ) or return;

    is(
        $parsed_dt->strftime($pattern),
        $input,
        'strftime output matches input'
    );
}

sub test_months {
    my $locale = shift;

    subtest(
        'months',
        sub {
            foreach my $month ( 1 .. 12 ) {
                subtest(
                    "Month $month",
                    sub { _test_one_month( $locale, $month ) },
                );
            }
        }
    );
}

sub _test_one_month {
    my $locale = shift;
    my $month  = shift;

    my $pattern = '%Y-%m-%d %B';

    my $dt
        = DateTime->now( locale => $locale )->truncate( to => 'month' )
        ->set( month => $month );
    my $input = $dt->strftime($pattern);
    my $strptime;
    is(
        exception {
            $strptime = DateTime::Format::Strptime->new(
                pattern  => $pattern,
                locale   => $locale,
                on_error => 'croak',
            );
        },
        undef,
        'constructor with month name (%B)'
    ) or return;

    my $parsed_dt;
    is(
        exception {
            $parsed_dt = $strptime->parse_datetime($input)
        },
        undef,
        "parsed $input"
    ) or return;

    is(
        $parsed_dt->strftime($pattern),
        $input,
        'strftime output matches input'
    );
}

sub test_am_pm {
    my $locale = shift;

    subtest(
        'am/pm',
        sub {
            foreach my $hour ( 0, 11, 12, 23 ) {
                subtest(
                    "Hour $hour",
                    sub { _test_one_hour( $locale, $hour ); },
                );
            }
        }
    );
}

sub _test_one_hour {
    my $locale = shift;
    my $hour   = shift;

    my $pattern = '%Y-%m-%d %H:%M %p';

    my $dt = DateTime->now( locale => $locale )->set( hour => $hour );
    my $input = $dt->strftime($pattern);
    my $strptime;
    is(
        exception {
            $strptime = DateTime::Format::Strptime->new(
                pattern  => $pattern,
                locale   => $locale,
                on_error => 'croak',
            );
        },
        undef,
        'constructor with meridian (%p)'
    ) or return;

    my $parsed_dt;
    is(
        exception {
            $parsed_dt = $strptime->parse_datetime($input)
        },
        undef,
        "parsed $input",
    ) or return;

    is(
        $parsed_dt->strftime($pattern),
        $input,
        'strftime output matches input'
    );
}

sub test_locale {
    my $locale = shift;

    my $strptime;
    is(
        exception {
            $strptime = DateTime::Format::Strptime->new(
                pattern  => '%Y-%m-%d',
                locale   => $locale,
                on_error => 'croak',
            );
        },
        undef,
        'constructor with locale'
    ) or return;

    my $input = '2015-01-30';
    my $parsed_dt;
    is(
        exception {
            $parsed_dt = $strptime->parse_datetime($input)
        },
        undef,
        "parsed $input",
    ) or return;

    is(
        $parsed_dt->locale->$code_meth,
        $locale,
        "code of locale for DateTime returned by parser is $locale"
    );
}

sub _utf8_output {
}
