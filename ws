#!/usr/bin/perl
#
# usage: ws [-o (diff python version)] [[ip(127.0.0.1)] port(8080)]
# -samy kamkar

use strict;

my $PYTHON = 'python';
my $other = $ARGV[0] eq "-o" ? shift : 0;
my $http = $other ? "SimpleHTTPServer" : "http.server";

my $ip = $ARGV[0] =~ /^\d+\.\d+\.\d+\.\d+$/ ? shift : "127.0.0.1";
my $port = $ARGV[0] =~ /^\d+$/ ? shift : 8080;
my @args = ('--bind', $ip);

if (!fork())
{
  sleep(2);
  exec("open", "http://$ip:$port");
}
system($PYTHON, "-m", $http, $port, @args);