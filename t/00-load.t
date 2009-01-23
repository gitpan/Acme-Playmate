#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Acme::Playmate' );
}

diag( "Testing Acme::Playmate $Acme::Playmate::VERSION, Perl $], $^X" );
