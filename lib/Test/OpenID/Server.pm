use warnings;
use strict;

package Test::OpenID::Server;

use base qw/HTTP::Server::Simple::CGI Test::HTTP::Server::Simple/;

         use Net::OpenID::Server;


         # From your OpenID server endpoint:
sub handle_request {

        my $self = shift;
        my $cgi = shift;
         my $nos = Net::OpenID::Server->new(
           get_args     => $cgi,
           post_args    => $cgi,
           get_user     => sub { return warn $ENV{'REQUEST_URI'} },
           is_identity  => sub{ my $u = shift; if ($u =~ /identity/) { return 1} else { return 0 } },
           is_trusted   => sub { my $u = shift; if ($u =~ /untrusted/||!$u) { return 0} else {return 1}},
           server_secret => 'squeamish_ossifrage',
           setup_url    => "http://example.com/pass-identity.bml",
         );
         my ($type, $data) = $nos->handle_page;
         if ($type eq "redirect") {
                 print "HTTP/1.0 301 REDIRECT\r\n";    # probably OK by now
                print "Location: $data\r\n\r\n";
         } else {
                 print "HTTP/1.0 200 OK\r\n";    # probably OK by now
                 print "Content-Type: $type\r\n\r\n$data";

         }
}

1;
