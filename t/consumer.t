use warnings;
use strict;

use Test::More 'no_plan';

use_ok('Test::OpenID::Server');
my $s   = Test::OpenID::Server->new;
my $URL = $s->started_ok("started server");

diag "OpenID server is $URL";

use_ok('Test::OpenID::Consumer');
my $c    = Test::OpenID::Consumer->new;
my $CURL = $c->started_ok("started consumer");

diag "OpenID consumer is $CURL";

$c->verify_openid( "$URL/identity/test" );

