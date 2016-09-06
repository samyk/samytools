#!/usr/bin/perl
#
# grep smart
#
# -n = find files that match this string and grep contents
# -o = output actual grep string
# -i = include regexp
# -e = exclude regexp
# -v = grep out AFTER grepping

my $grep = '/opt/local/bin/grep';
use strict;
die "usage: $0 [files] [-o] [-n <file match>] [-i=file] [-e=file] [-options] <match> [-v !match]\n" unless @ARGV;

my ($no, $noi, $stdin, $matchfiles);

# if no piped in data (g ...), recursively crawl
if (-t STDIN)
{
	$stdin = "r";
}

for (my $i = 0; $i < @ARGV; $i++)
{
	my $opt = $ARGV[$i];
	if ($opt eq "-n")
	{
		$matchfiles = splice(@ARGV, $i+1, 1);
		splice(@ARGV, $i, 1);
	}
}
if (@ARGV >= 3 && $ARGV[-3] !~ /^-/ && $ARGV[-2] =~ /^-v(i)?$/)
{
	$noi = $1 ? "(?i)" : "";
	$no = pop(@ARGV);
	pop(@ARGV);
}

my $out = 0;
for (my $i = 0; $i < @ARGV; $i++)
{
	my $opt = $ARGV[$i];
	$opt =~ s/^-?-i=/--include=/;
	$opt =~ s/^-?-e=(.*)/--exclude=$1 --exclude-dir=$1/;
	$opt =~ s/^-(\w*)e(\w*)$/-$1$2/;
	$opt eq "-" ? splice(@ARGV, $i--, 1) : ($ARGV[$i] = $opt);

	if ($opt eq "-o")
	{
		$out++;
		splice(@ARGV, $i--, 1);
	}
}

splice(@ARGV, 0, 0, $grep, ($ARGV[0] =~ /^-/ || @ARGV == 1) && -t STDIN ? <*> : ());
#splice(@ARGV, -1, 0, "--exclude-dir=.git", "--exclude-dir=.svn", "--color=always", "-srne");
#splice(@ARGV, -1, 0, "--exclude-dir=.git", "--exclude-dir=.svn", "--color=always", "-TPsne");
splice(@ARGV, -1, 0, "--exclude-dir=.git", "--exclude-dir=.svn", "--color=always", "-TPs${stdin}ne");

print STDERR join(" ", @ARGV) . "\n" if $out;
if (length($no))
{
	eval("use System2");
	my ($out, $err) = system2(@ARGV);
	my @out = split("\n", $out);
	foreach my $line (@out)
	{
		(my $tmp = $line) =~ s/\e\[(?:\d+(?:;\d+)?)?m|\e\[K//g;
		print "$line\n" if $tmp !~ /$noi$no/i;
	}
	print STDERR $err;
}
else
{
	system(@ARGV);
}
