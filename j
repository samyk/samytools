#!/usr/bin/perl
#
# join arguments or stdin lines together with optional string
# -samy kamkar

use strict;
use Getopt::Std;

my $nopipe = -t STDIN;
my %o;

getopts('hs:', \%o);
usage() if $o{h};
my $join = $o{s};

my @out = @ARGV ? @ARGV : map { chomp; $_ } <>;
print join($join, @out);
print "\n" if $nopipe;

sub usage
{
  die "usage: $0 [-s 'join string' (default none)] [strings to join, read from STDIN]\n";
}
