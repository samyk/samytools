#!/usr/bin/perl

use strict;
if (!@ARGV)
{
		print "usage: $0 [times ..]\n";
		print time . "\n";
		exit;
}

for (my $i = 0; $i < @ARGV; $i++)
{
	$_ = $ARGV[$i];
	my $orig = $_;
  s/\.//;
	my $ms = "000";

	# parse pb
	if (length($_) == 14)
	{
		my $out = `echo $_ | rp | protoc --decode_raw`;
		print $out;
		if ($out =~ /: (\d+)/)
		{
			$_ = $1;
		}
	}
	if (length($_) == 13)
	{
		s/(...)$//;
		$ms = $1;
		my $t = localtime($_);
		$t =~ s/(\d+:\d+) /$1.$ms /;
		print "$t\n";
	}
	elsif (length($_) == 10 || length($_) == 9)
	{
		print localtime($_) . "\n";
	}
	elsif ($orig =~ /^(\d{10})\.(\d+)$/)
	{
	  print localtime($1) . $2 . "\n";
	}
	else
	{
		print "Don't understand $_\n";
		next;
	}

	if ($ARGV[$i+1] =~ /^\d\d?$/)
	{
		print convert_time($_ . $ms, $ARGV[++$i]) . "\n";
	}
}


# converts time to 
sub convert_time
{
    my ($t, $i) = @_;
    $i = reverse(unpack("b4", pack("s", $i)));
    my $b = unpack("b42", pack("q", $t));

    $b =~ s/(.{7})/1 . reverse($1)/ge;
    $b =~ s/1(.{7})$/0$1/;
# 0### #?T?

    # first byte: ?, 4 bits for index, ?, type, ?
    $b = "0${i}000" . $b;

    return unpack("H14", pack("B56", $b));
}


