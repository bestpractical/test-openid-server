#!perl
use warnings;
use strict;

package Test::OpenID::Server;
use Net::OpenID::Server;
use base qw/Test::HTTP::Server::Simple HTTP::Server::Simple::CGI/;

our $VERSION = '0.01';

=head1 NAME

Test::OpenID::Server - setup a simulated OpenID server

=head1 SYNOPSIS

Test::OpenID::Server will provide a server to test your OpenID client
against.  To use it, do something like this:

   use Test::More tests => 1;
   use Test::OpenID::Server;
   my $server   = Test::OpenID::Server->new;
   my $url_root = $server->started_ok("server started ok");

Now you can run your OpenID tests against the URL in C<$url_root>.

=head1 METHODS

=head2 new

Create a new test OpenID server

=head2 started_ok

Test whether the server started, and if it did, return the URL it's
at.

=head1 INTERAL METHODS

These methods implement the HTTP server (see L<HTTP::Server::Simple>).
You shouldn't call them.

=head2 handle_request

=cut

sub handle_request {
    my $self = shift;
    my $cgi = shift;

    if ( $ENV{'PATH_INFO'} eq '/openid.server' ) {
        # We're dealing with the OpenID server endpoint
        
        my $nos = Net::OpenID::Server->new(
            get_args      => $cgi,
            post_args     => $cgi,
            get_user      => \&_get_user,
            is_identity   => \&_is_identity,
            is_trusted    => \&_is_trusted,
            server_secret => 'squeamish_ossifrage',
            setup_url     => "http://example.com/pass-identity.bml",
        );
        my ($type, $data) = $nos->handle_page( redirect_for_setup => 1 );
        if ($type eq "redirect") {
            print "HTTP/1.0 301 REDIRECT\r\n";    # probably OK by now
            print "Location: $data\r\n\r\n";
        } else {
            print "HTTP/1.0 200 OK\r\n";    # probably OK by now
            print "Content-Type: $type\r\n\r\n$data";
        }
    }
    else {
        # We're dealing with an OpenID identity page
        print "HTTP/1.0 200 OK\r\n";
        print "Content-Type: text/html\r\n\r\n";
        print <<"        END";
<html>
  <head>
    <link rel="openid.server" href="$ENV{'SERVER_URL'}openid.server" />
  </head>
  <body>
    <p>OpenID identity page for $ENV{'PATH_INFO'}</p>
  </body>
</html>
        END
    }
}

sub _get_user {
    return $ENV{'PATH_INFO'};
}

sub _is_identity {
    my $u = shift; 
    if ($u =~ /identity/) { 
        return 1;
    } 

    return 0;
}

sub _is_trusted { 
    my $u = shift; 
    if ($u =~ /untrusted/||!$u) { 
        return 0;
    }
    
    return 1;
}

=head1 AUTHORS

=head1 COPYRIGHT

=head1 LICENSE

You may distribute this module under the same terms as Perl 5.8 itself.

=cut

1;
