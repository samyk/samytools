#!/usr/bin/perl
#
# factor numbers using yafu
# -samyk

use strict;
die "usage: $0 [-v] <number>\n" unless @ARGV;

my @factors;
my $num = shift;
my $YAFU = "yafu";

#83473593554391843334619428139045661537976651941410655062632649869770538548577
my $verbose = 1;

factor($num);
print "factors: @factors\n";

sub factor
{
  my $num = shift;

  my ($factor1, $factor2, $ecm);
  print "Running: ecm($num)\n";
  open(F, "$YAFU 'ecm($num)'|") || die;
  while (<F>)
  {
    print if ($verbose);

    # we may need to sqrt() the number
    if (/^ecm/)
    {
      $ecm++;
    }
    elsif (/^P\d\s*=\s*(\d+)$/)
    {
      $factor1 = $1;
      push @factors, $factor1;
    }
    #elsif (/factors found/)
    elsif (/^(\d+)$/)
    {
      $factor2 = $1;
    }
  }
  print "$factor1 - $factor2 - $ecm\n";

  # found it!
  if ($factor2 == 1) { print "factored!\n\n" }
  elsif ($factor2 == $num)
  {
    my $sqrt = sqrt($num);
    push @factors, $sqrt, $sqrt;
  }
  else
  {
    factor($factor2);
  }
}

