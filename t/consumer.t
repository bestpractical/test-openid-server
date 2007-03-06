use warnings;
use strict;

use Test::More tests => 4;

use_ok('Test::OpenID::Server');
my $s   = Test::OpenID::Server->new;
my $URL = $s->started_ok("started server");

use_ok('Test::OpenID::Consumer');
my $c    = Test::OpenID::Consumer->new;
my $CURL = $c->started_ok("started consumer");

$c->verify_openid( "$URL/identity/test" );

