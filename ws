#!/usr/bin/perl
#
# usage: ws [-o (diff python version)] [port (8080)]
# -samy kamkar

use strict;

my $PYTHON = 'python';
my $other = $ARGV[0] eq "-o" ? shift : 0;
my $http = $other ? "http.server" : "SimpleHTTPServer";
my $port = shift || 8080;

system("open", "http://localhost:$port");
system($PYTHON, "-m", $http, $port);