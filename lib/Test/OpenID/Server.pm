#!perl
use warnings;
use strict;

package Test::OpenID::Server;
use Net::OpenID::Server;
use base qw/Test::HTTP::Server::Simple HTTP::Server::Simple::CGI/;

our $VERSION = '0.01';

sub handle_request {

    my $self = shift;
    my $cgi = shift;
    my $nos = Net::OpenID::Server->
      new(get_args      => $cgi,
          post_args     => $cgi,
          get_user      => \&_get_user,
          is_identity   => \&_is_identity,
          is_trusted    => \&_is_trusted,
          server_secret => 'squeamish_ossifrage',
          setup_url     => "http://example.com/pass-identity.bml",
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

sub _get_user {
    return warn $ENV{'REQUEST_URI'};
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

1;
