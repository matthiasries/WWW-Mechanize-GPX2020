#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::Mechanize::GPX2020' );
}

diag( "Testing WWW::Mechanize::GPX2020 $WWW::Mechanize::GPX2020::VERSION, Perl $], $^X" );
