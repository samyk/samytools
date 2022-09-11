#!/usr/bin/perl

if ($ARGV[0] && !-e $ARGV[0])
{
	$p = "-p" . shift;
}

my @files = @ARGV ? @ARGV : <*.rar>;

print "@files\n";
foreach (grep { /part0?1\.rar/ || !/part\d/ } @files)
{
	print "Unrarring $_\n";
	system("unrar", "x", $p, "-o+", $_);
}

my @files = @ARGV ? @ARGV : <*.zip>;

print "@files\n";
foreach (@files)
{
	print "Unzipping $_\n";
	system("unzip", "-n", $_);
}
