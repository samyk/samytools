#!/usr/bin/perl
#
# TODO:
#  - support passing a directory to -R
#  - long lines doesn't work with -v
#  - make correct params
#  - add documentation on each param

=pod

  g(rep++)
  -samy kamkar

usage: g [files] [-aoRz] [-n <file match>] [-i=file] [-e=file] [-options] <match> [-v !match] [-x <cmd, eg ls -lh>]

any normal options will be passed along to egrep

examples:
 g the_match
 -> greps * recursively for /the_match/

 g some_file foo -v bar
 -> greps some_file matching /foo/ while NOT matching /bar/

 find . | g txt$ -x ls -lh
 -> perform `ls -lh` on every file ending in 'txt'

 g -n file_name_match
 -> greps recursively for all file NAMES that match /file_match/

enabled by default: recursive, color, line numbers, tabs, ignore binaries, PCRE (perl regexpes), ignores .git/.svn

options:
-R no recursion
-k prints everything but colorizes matches
-N no line numbers
-L line numbers
-r (same as -R)
-x cmd (runs `cmd <matching line>` for every matching line)
-a (search binary files)
-o (output actual grep command)
-i (case insensitive)
-i=glob (search only files whose base name matches glob)
-e=glob (skip files who base name matches glob)
-v dont_match (ignore lines that match /dont_match/)
-n (find files that match this string and grep contents)
-z (gunzip files and grep them as well as non-gzipped files)
all other options will be passed along to egrep

=pod

# show lines in all files (in ., recursively) that match 'foo' but NOT 'bar'
g foo -v bar

# grep files/dirs a, b, and c for number.number (perl regexp \d\.\d)
g a b c '\d\.\d'

# perform `ls -lh` on every file ending in 'txt'
find . | g txt$ -x ls -lh

=cut

my $grep = '/opt/local/libexec/gnubin/grep'; # /opt/local/bin/grep
$|++;

use strict;
use Term::ANSIColor;

# XXX make this configurable
my $MAXLEN = 700; # max bytes to print in a line to avoid long lines from showing entirely
die "usage: $0 [files] [-Nao] [-n <file match>] [-i=file] [-e=file] [-options] <match> [-v !match] [-x <cmd, eg ls -lh>]\n" unless @ARGV;
#my $DEFAULTS = "-I";

my ($no, $noi, $stdin, $matchfiles, $binary, $color);

my $piped = !-t STDIN;
if ($piped)
{
  $binary = 1;
}
# if no piped in data (g ...), recursively crawl
else
{
	$stdin = "r";
}

# stdout = true if piping out, eg g | something
my $stdout = -t STDOUT;
my $linenos = 0;
my @run;
#print STDERR "binary=$binary piped=$piped stdin=$stdin stdout=$stdout\n";

for (my $i = 0; $i < @ARGV; $i++)
{
  #my $opt = $ARGV[$i];
  if ($ARGV[$i] =~ /^-(\w+)$/)
  {
    my $splice = 0;
    foreach my $opt (split //, $1)
    {
      $opt = "-$opt";

      # no line numbers
      if ($opt eq "-N")
      {
        $linenos = 0;
        $ARGV[$i] =~ s/N//;
        $splice = 1;
      }

      # line numbers
      if ($opt eq "-L")
      {
        $linenos = 1;
        $ARGV[$i] =~ s/L//;
        $splice = 1;
      }

      # show all text but colorize output
      elsif ($opt eq "-k")
      {
        $ARGV[$i] =~ s/k//;
        $splice = 1;
        $color = 1;
      }

      # find files with this name
      elsif ($opt eq "-n")
      {
        $matchfiles = splice(@ARGV, $i+1, 1);
        $ARGV[$i] =~ s/n//;
        $splice = 1;
        #splice(@ARGV, $i, 1);
      }

      # no recursion
      elsif ($opt eq "-R" || $opt eq "-r")
      {
        $stdin =~ s/r//;
        $ARGV[$i] =~ s/[rR]//;
        $splice = 1;
        #splice(@ARGV, $i, 1);
      }

      # match binary files
      elsif ($opt eq "-a")
      {
        #$binary = splice(@ARGV, $i, 1);
        $binary = 1;
        #$ARGV[$i] =~ s/b/a/;
        $splice = 1;
      }

      # if running a program on each match
      elsif ($opt eq "-x")
      {
        @run = splice(@ARGV, $i+1, @ARGV);
        $stdout = 0;
        $ARGV[$i] =~ s/x//;
        #splice(@ARGV, $i, 1);
        $splice = 1;
      }
    }
    splice(@ARGV, $i, 1) if ($ARGV[$i] eq "-");
    #splice(@ARGV, $i, $splice) if $splice;
  }
}

if (@ARGV >= 3 && $ARGV[-3] !~ /^-/ && $ARGV[-2] =~ /^-(i)?v(i)?$/)
{
  $noi = $1 || $2 ? "(?i)" : "";
  $no = pop(@ARGV);
  pop(@ARGV);
}

my $run;
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

# grep features we want
splice(@ARGV, 0, 0, $grep, ($ARGV[0] =~ /^-/ || @ARGV == 1) && -t STDIN ? <*> : ());
# don't parse .git dirs
splice(@ARGV, -1, 0, "--exclude-dir=.git", "--exclude-dir=.svn", "-TPs${stdin}");
# we want color
#splice(@ARGV, -1, 0, "--color=always");
splice(@ARGV, -1, 0, "--color=always") if $stdout;
# if we want line numbers
splice(@ARGV, -1, 0, "-n") if $stdout && $linenos;
# don't process binary files unless we want to
splice(@ARGV, -1, 0, "-I") unless $binary;
# pattern follows
splice(@ARGV, -1, 0, "-e");

$ARGV[-1] .= '|$' if $color; # colorize output but show everything

print STDERR join(" ", @ARGV) . "\n" if $out;
if (length($no))
{
  eval("use System2");
  my ($out, $err) = system2(@ARGV);
  my @out = split("\n", $out);
  foreach my $line (@out)
  {
    (my $tmp = $line) =~ s/\e\[(?:\d+(?:;\d+)?)?m|\e\[K//g;
    if (@run)
    {
      run(@run, $line);
    }
    else
    {
      print "$line\n" if $tmp !~ /$noi$no/i;
    }
  }
  print STDERR $err;
}
else
{
  if (@run)
  {
    my @out = map { chomp; $_ } `@ARGV`;
    run(@run, @out);
    #map { chomp; system(@run, $_) } `@ARGV`;
  }
  else
  {
    run(@ARGV);
  }
}

# handle long lines
sub run
{
  # TODO: add support for handling oversized piped data
  if ($piped)
  {
    system(@_);
    return;
  }

  my ($cmd, @args) = @_;
  my $match = $args[-1];

  open(GREP, "-|", $cmd, @args) || die "Can't run `$cmd @args`: $!";

  # check for case insensitivity
  $match = "(?:(?i)$match)" if grep { $_ eq "-i" } @args;

  # grab 3 extra bytes of ansicolor after :
  my $colorbytes = $stdout ? ".{7}" : "";
  #print "cb=$colorbytes\n";

  while (<GREP>)
  {
    my $d = $_;
    #print "d=$d\n";
    # XXX add option to disable this cutting
    if (length($d) > $MAXLEN)
    {
      my $nl = 0;

      # grab/print file name
      $d =~ s/^(.*?.:$colorbytes)//;
      print $1;
      #print " cb=$colorbytes 1=$1\n";

      while ($d =~ s/^(.*?)(.{0,$MAXLEN})($match)(.{0,$MAXLEN})//s)
      {
        my ($extra, $pre, $m, $post) = ($1, $2, $3, $4);
        #print "e=$extra p=$pre m=$m($match) P=$post\n";
        print colored("<...>", 'cyan') if $extra;
        #print "(EXTRA=$extra)";
        print $pre;
        print $m;
        if ($post =~ /$match/)
        {
          $d = $post . $d;
          pos($d) = 0;
        }
        else
        {
          print $post;
        }
        $nl++ if (($pre . $m . $post) =~ /\n/);
      }
      print colored("<...>", 'cyan') if $d;
      print "\n" if !$nl;
    }
    else
    {
      print;
    }
  }
}
