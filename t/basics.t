use warnings;
use strict;

use Test::More tests => 8;

use_ok('Test::OpenID::Server');
my $s   = Test::OpenID::Server->new;
my $URL = $s->started_ok("start server");

diag "root is $URL";

use_ok('Test::WWW::Mechanize');
my $mech = Test::WWW::Mechanize->new;

$mech->get_ok( "$URL/identity/test", "fetch identity page" );
$mech->content_contains( "OpenID identity page for /identity/test", "got identity page" );
$mech->content_contains( "$URL/openid.server", "contains correct server URL" );

$mech->get_ok( "$URL/openid.server", "fetch openid server endpoint" );
$mech->content_contains( "OpenID Endpoint", "got openid server endpoint" );

