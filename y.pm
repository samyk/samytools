# general reusable functions for perl
# necessary for some tools at https://github.com/samyk/samytools
#
# -samy kamkar :: https://samy.pl

$|++;

use strict;
no strict 'subs';
#use lib "/Users/samy/Code/samyweb";
#use samyweb;

#use Date::Manip;
#use Storable qw/freeze thaw/;
use POSIX qw(strftime ceil floor);
use MIME::Base64 qw(decode_base64 encode_base64);
#use HTML::Parser;
use Data::Dumper;
#use HTML::Entities;

our %_y;
=cut
# functions typically accept one or more params
# if it can support multiple params to do the same op on, it should return a list of the results UNLESS !wantaray and only one param, in which case it should return the single value
# this allows us to do: $str = chomps("hi\n"); # $str will be "hi" instead of 1 (scalar value of single element list)
# but still can do: @str = chomps("hi\n", "bye\n"); # @str will be ("hi", "bye")
# and: $cnt = chomps("hi\n", "bye\n"); # $cnt = 2
sub template
{
}
=cut

# pwd
sub pwd { &cwd }
sub cwd
{
  use Cwd;
  return getcwd();
}

# udp socket
sub udp
{
  return _sock('udp', @_)
}

sub tcp
{
  return _sock('tcp', @_)
}

sub _sock
{
  my ($proto, $host, $port, %opts) = @_;
  use IO::Socket;
  return IO::Socket::INET->new(
    Proto    => $proto,
    PeerAddr => $host,
    PeerPort => $port || 1337,
    %opts
  )
}

# arp table
sub arp
{
  my %arp = map
  {
    my @s = split /[\s()]+/;
    $s[3] eq 'incomplete' ? () :
      $s[1] => cleanmac($s[3])
  } runenv('arp -na');
  return @_ ? @arp{@_} : %arp;
}

# host/ip to mac address
sub host2mac
{
  return arp(host2ip($_[0]));
}

# host to ip address
sub host2ip
{
  use Socket;

  my $host = shift;
  return $host if $host =~ /^\d+\.\d+\.\d+\.\d+$/;

	my $inet = inet_aton($host);
  return inet_ntoa($inet) if $inet;
}

sub cleanmac
{
  my $mac = shift;
  $mac = lc($mac);
  $mac =~ s/(\w?)(\w)(\W|$)/($1 || 0) . $2/eg;
  return $mac;
}

# rerun the script as root if not already
sub rerun_as_root
{
  return if $< == 0;
  my @sudo = grep -e, <{/usr,}/{s,}bin/sudo>;
  die "no sudo" if !@sudo;
  print STDERR "more than one sudo: @sudo\n" if @sudo > 1;

  exec($sudo[0], $^X, $0, @ARGV);
}

# enable/disable utf8
sub utf8
{
  binmode(STDOUT, shift ? ":utf8" : ":raw");
}

# helper for returning a single value vs list so single value list doesn't get treated in scalar context
# caveat - multi only runs the func once if multiple
# mapw { block } list
sub mapw (&@)
{
  my $fn = shift;

  # if we don't want an array (we want scalar) and there's only one value, return it (otherwise return the full list which gets treated as numeric)
  !wantarray && @_ == 1 ? &$fn($_ = $_[0]) : map &$fn($_), @_
}

# chomp strings inline and return
sub chomps
{
  mapw {
    substr($_, length() - 1, 1) eq $/
      ? substr($_, 0, length() - 1)
      : $_
  } @_
}

# multiw(wantarray, list)
sub multiw
{
  !wantarray && @_ == 1 ? $_[0] : @_
}

# return file type
sub file
{
  my $file = shift;
  my $FILE_PATH = "file";
  my @FILE_OPTS = qw/-b/;
  return chomps(run($FILE_PATH, @FILE_OPTS, $file));

#  open(my $fh, "-|", $FILE_PATH, @FILE_OPTS, $file);
#  chomp(my $out = join "", <$fh>);
#  close($fh);

#  return $out;
}

# safe run and return stdout but find path in env
# in list context, returns list of lines, in scalar context returns single value
sub vrunenv
{
  my $cmd = shift;
  $cmd =~ s~^([^.\s/]+)(\s|$)~env_path($1) . $2~e;
  return vrun($cmd, @_);
}

# safe run and return stdout but find path in env
# in list context, returns list of lines, in scalar context returns single value
sub runenv
{
  my $cmd = shift;
  $cmd =~ s~^([^.\s/]+)(\s|$)~env_path($1) . $2~e;
  return run($cmd, @_);
}


# safe run (verbose)
sub runv
{
  _run(1, @_)
}

# safe run and return stdout
# in list context, returns list of lines, in scalar context returns single value
sub run
{
  _run(0, @_)
}

sub _run
{
  my $verbose = shift;

  # safely open
  open(my $fh, "-|", @_);
  print STDERR join(" ", map { "'$_'" } @_), "\n" if $verbose;
  return wantarray ? <$fh> : join "", <$fh>;
}

# safe run but support a string and interpolate, eg: safe_run(
# useful for just doing: runp('$FFMPEG --something $unsafe_user_input @list'), 
# runp will return the output but will interpolate the variables itself and split the string by whitespace BEFORE interpolation, thus making the command above safe (the $unsafe_user_input will be treated as a single paramenter while the array gets split into each item
sub UNFINISHED_runp
{
  no strict;
  my @cmd = map { s/\$(\w+)/${$1}/eg; /^\@(\w+)$/ ? @{$_} : $_ } split(/\s+/, $_[0]);
  open(my $fh, "-|", @cmd);
  print STDERR join(" ", map { "'$_'" } @cmd), "\n";
  return join "", <$fh>;
}

# convert html to text
sub html2text
{
  u("HTML::Entities");
  return HTML::Entities::decode_entities(shift);
}

# more easily b64 decode/encode
sub b64 { &base64 }
sub b64d { &decode_base64 }
sub b64e { &encode_base64 }
sub base64
{
  return $_[0] =~ /^[A-Za-z0-9+\/\r\n]+={0,2}$/ ? decode_base64($_[0]) : encode_base64($_[0]);
}

# encode/decode json
sub json
{
  my $data = shift;

  my $jsonv;
  my @modules = ("JSON::XS", "JSON");
  my $module = pmt(@modules);
  if (!$module)
  {
    eval("use $_") for @modules;
  }

  # read in file if file passed
  $data = cat($data) if -f $data;

  return !ref($data) ? decode_json($data) : encode_json($data);
}

# test for modules
sub pmt
{
  my @loaded;
  foreach my $module (@_)
  {
    if (eval("\$$module::VERSION"))
    {
      push @loaded, $module;

      # if we only need one, bail out
      last if !wantarray;
    }
  }

	return wantarray ? @loaded: $loaded[0];
}

# tail -f
sub tail
{
  my $fh = shift;
  seek($fh, 0, 1);
  return <$fh>;
}


# numeric sort
sub sortn
{
  return sort { $a <=> $b } @_;
}

sub scale
{
	my ($val, $wasfrom, $wasto, $nowfrom, $nowto);

	if (@_ == 3)
	{
		($val, $wasto, $nowto) = @_;
		$wasfrom = $nowfrom = 0;
	}
	else
	{
		($val, $wasfrom, $wasto, $nowfrom, $nowto) = @_;
	}
		
	$val -= $wasfrom;
	$val /= ($wasto - $wasfrom);
	$val *= ($nowto - $nowfrom);
	$val += $nowfrom;

	return $val;
}

# get epoch from date
sub epoch
{
	return UnixDate($_[0], "%s");
}

# time in ms/us
sub mstime
{
  u("Time::HiRes");
  return Time::HiRes::time();
}

# pass in date, format string or default to MM/DD/YYYY
sub date
{
	my ($fmt, @time) = @_;
	$fmt ||= "%m/%d/%Y";
	if (length $fmt && $fmt !~ /%/)
	{
		unshift @time, $fmt;
		$fmt = "%m/%d/%Y";
	}
	@time = localtime() if !@time;

  eval("use POSIX qw(strftime)");
	return strftime $fmt, @time;
}

sub network
{
	my %net;

	# get default interface
	my ($netstat) = grep { /^default/ } `/usr/sbin/netstat -nr`;
	(undef, $net{'gateway'}, undef, undef, undef, $net{'interface'}) = split(/\s+/, $netstat);

	# get ip info
	my @ifconfig = `/sbin/ifconfig $net{'interface'}`;
	($net{'ip'}) = map { /inet (\S+)/ } grep { /inet\s/ } @ifconfig;
	($net{'mac'}) = map { /ether (\S+)/ } grep { /ether\s/ } @ifconfig;


	return %net;
}

sub getfile
{
  #  u("LWP::Simple", []);
  #  u("LWP::UserAgent", []);
  #  $_y{ua} = new LWP::UserAgent;
  #  $_y{ua}->agent("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36");
  #
  #  $req = new HTTP::Request 'GET' => 'http://www.sn.no/libwww-perl';
  #  $req->header('Accept' => 'text/html');
  #  $res = $ua->request($req);
  #
	my $url = shift;
	my $file = shift;

  # if we passed a dir, grab filename from url
  if (-d $file)
  {
    my $dir = $file;
    $url =~ m~/([^/]+)$~;
    $file = "$dir/$1";
  }
  # no file passed, grab from url
	elsif (!$file && $url =~ m~/([^/]+)$~)
	{
		$file = $1;
	}

  print "out($file, get($url))\n";
  return `wget -q -O $file -4 -c -e robots=off --no-check-certificate --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.42 Safari/537.36" --header="Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language: en-us,en;q=0.5" --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" --header="Keep-Alive: 300" $url`;
  #out($file, get($url));
  ##out($file, LWP::Simple::get($url));
	return $file;
}

# email(subject, body, to, from, gmail pass, [cc ..])
sub email
{
	my $subject = shift;
	my $body = shift;
	my $to = shift;
	my $from = shift;
	my $pass = shift;
	my @cc = @_;

	eval("use Net::SMTP::TLS");

  #my $pass = cat("~/.smtppass");
  #$pass =~ s/#.*//g;
  #$pass =~ s/\n//g;

	my $mailer = new Net::SMTP::TLS(
		'smtp.gmail.com',
		Hello   =>      'smtp.gmail.com',
		Port    =>      587,
		User    =>      $from,
		Password=>      pack("H*", $pass)
	);
	$mailer->mail($from);
	$mailer->to($to);
	foreach my $cc (@cc)
	{
		$mailer->cc($cc);
	}
	$mailer->data;
	$mailer->datasend("To: $to\n");
	$mailer->datasend("From: $from\n");
	foreach my $cc (@cc)
	{
		$mailer->datasend("Cc: $cc\n");
	}
	$mailer->datasend("Subject: $subject\n");
	$mailer->datasend("\n");
	$mailer->datasend($body);
	$mailer->dataend;
	$mailer->quit;
}

# DBM::Deep db (multidimensional)
sub ddb
{
	my ($f) = @_;

	u("DBM::Deep");
	
	return DBM::Deep->new($f);
}

sub get
{
  #u("LWP::Simple", []);
  #return LWP::Simple::get(@_);

  # todo - move to LWP, need better headers to avoid detection
  return `wget -q -O - -4 -c -e robots=off --no-check-certificate --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.42 Safari/537.36" --header="Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language: en-us,en;q=0.5" --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" --header="Keep-Alive: 300" @_`;

  my @cmd = (qw|wget -4 -c -e robots=off --no-check-certificate|, '--user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.42 Safari/537.36"', qw|--header="Accept:text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language:en-us,en;q=0.5" --header="Accept-Charset:ISO-8859-1,utf-8;q=0.7,*;q=0.7" --header="Keep-Alive:300"|);

  my $html = run(@cmd, @_);
  return $html;

  #u("LWP::UserAgent", []);
  #$_y{ua} = new LWP::UserAgent;
  #$_y{ua}->agent("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36");

  #$_y{req} = new HTTP::Request 'GET' => $_[0];
  #$_y{req}->header('Accept' => 'text/html');
  #$_y{res} = $_y{ua}->request($_y{req});
  #return $_y{res}->content;
}

# use a module, die if it doesn't exist (or offer to install?)
# usage: u(module, [version], [list of funcs OR arrayref of funcs], dont-install)
sub u
{
	my ($module, @rest) = @_;

  # perl supports: use module [version] [list]
  # grab version if we have it
	my $wantver = $rest[0] =~ /^\d+([._]\d+)+$/ ? shift(@rest) : 0;
  # grab installed if we have it
	my $installed = $rest[-1] == /^[01]$/ ? pop(@rest) : 0;

  # the rest of args are funcs to pass, if any
	my @funcs = ref($rest[0]) eq "ARRAY" ? @{$rest[0]} : @rest;

  # get module version (if loaded)
	my $version = eval("\$${module}::VERSION");

  # return if already loaded
  return $version if $version;

  # try to use the module
  my $usestr = "use $module $wantver " . (@rest ? "qw/@funcs/" : "") . "; 1";
	if (!eval($usestr))
	{
		if ($installed)
		{
			die "Still can't use module $module after installation: $@\n";
		}

		print STDERR "Can't load module: $module\n$@\nAttempting to install $module\n";
		return pmi($module);
	}

	return eval("\$${module}::VERSION");
}

sub bdb
{
	my ($f, $readonly) = @_;

	u("BerkeleyDB");
	if ($readonly && !-e $f)
	{
		die "BerkeleyDB `$f` does not exist!";
	}

	my %h;
	tie %h, "BerkeleyDB::Hash",
		-Filename => $f,
		-Flags    => BerkeleyDB::DB_CREATE
	or die "Cannot open file: $! $BerkeleyDB::Error\n" ;

	return \%h;
}

# out(outfile, data to write)
sub out
{
	my $data = cat($_[0], 1);

  my $fh;
	if (!open($fh, ">$_[0]"))
	{
		print STDERR "Can't write to $_[0]: $!";
		return;
	}
	print $fh $_[1];
	close($fh);

	return $data;
}

# append(filename, data[, 1 to not fail])
sub append
{
  my $fh;
	if (!open($fh, ">>$_[0]") && !$_[2])
	{
		print STDERR "Can't append to $_[0]: $!";
		return;
	}
	print $fh $_[1];
	close($fh);
}

# readconf(file, don't die on fail, don't interpolate)
# read config and return hashref
sub readconf
{
  my (%data, $key);

  foreach (cat(@_))
  {
    s/\s*#.*//;
    next if /^\s*$/;

    # [something "hi"]
    if (/^\s*\[\s*(\S+)?(?:\s+"(.*)")?\s*\]$/)
    {
      $key = ($2 ? $data{$1}{$2} : $data{$1}) = {};
    }
    elsif (/^\s*(\S+)\s*=\s*(.*)$/)
    {
      $key->{$1} = $2;
    }
  }

  return \%data;
}

# interpolate ~
sub path
{
  $_[0] =~ s|^~/|$ENV{HOME}/|;
  return $_[0];
}

# cat(filename[, 1 to not fail[, 1 to not interpolate ~[, lines]]])
sub cat
{
  my ($dir, $nofail, $nointerp, $lines) = @_;

  $dir = $nointerp ? $dir : path($dir);
  my $fh;
  if (!open($fh, "<$dir"))
  {
    if (!$nofail)
    {
      print STDERR "Can't read $dir: $!\n";
    }
    return;
  }

  my @data = $lines ? map { <$fh> } 1 .. $lines : <$fh>;
  close($fh);

  return wantarray ? @data : join "", @data;
}

sub scat
{
  return map { s/\r?\n$//; $_ } cat(@_);
}

# return ordered array of csv header
sub csvheader
{
  my ($file, $delim) = @_;
  $delim = ',' unless length($delim);

  # get first line from file
  my ($line) = scat($_[0], undef, undef, 1);

  # grab our header
  my @hdr = map { s/^"(.*)"$/$1/; $_ } split /$delim/, $line;

  return @hdr;
}

# return array of hashes/arrays of csv data
sub csv
{
  my ($file, $delim, $noHdr) = @_;
  $delim = ',' unless length($delim);

  # get lines from file
  my @lines = scat($_[0]);
  if ($noHdr)
  {
    # return array of array refs, each array ref is a row
    return map { [ split /$delim/ ] } @lines;
  }

  # grab our header
  my @hdr = map { s/^"(.*)"$/$1/; $_ } split /$delim/, shift(@lines);

  my @return;
  foreach my $row (@lines)
  {
    my @data;
    while (length $row)
    {
      if ($row =~ s/^"(.*?)"(?:$delim|$)|^(.*?)(?:$delim|$)//)
      {
        #print "k - $1 - $2\n";
        push @data, $1 . $2;
      }
      else
      {
        die "weird row - $row\n";
      }
    }
    #my @data = split /$delim/, $row;
    push @return, { map { $hdr[$_] => $data[$_] } 0 .. $#hdr };
    $return[-1]{_orig} = $row;
  }

  return @return;
}

# return sqlite object
sub sqlite
{
	return DBI->connect("dbi:SQLite:dbname=$_[0]","","", { AutoCommit => 1 });
}

sub dbh
{
	u("DBI");
	my ($db, $user, $pass, $host, $type, @opts) = @_;
	$type ||= "mysql";

	my $str = "DBI:$type:$db";
	if ($host)
	{
		$str .= ";host=$host";
	}
	
	return DBI->connect($str, $user, $pass, { AutoCommit => 1, @opts });
}

sub md5
{
	u("Digest::MD5");
	return wantarray ? map { Digest::MD5::md5_hex($_) } @_ : Digest::MD5::md5_hex($_[0]);
}

sub sha256
{
	u("Digest::SHA");
	return wantarray ? map { Digest::SHA::sha256_hex($_) } @_ : Digest::SHA::sha256_hex($_[0]);
}

sub sha1
{
	u("Digest::SHA");
	return wantarray ? map { Digest::SHA::sha1_hex($_) } @_ : Digest::SHA::sha1_hex($_[0]);
}

my $__pm;
sub forksub
{
	my ($max, $func, @params) = @_;
	if (!$max && $__pm)
	{
		$__pm->wait_all_children;
		return;
	}

	if (!$__pm)
	{
		$__pm = new Parallel::ForkManager($max); 
	}

	$__pm->start and next;
	&{$func}(@params);
	$__pm->finish;

}

# install a perl module
sub pmi
{
	foreach my $module (@_)
	{
		pmi_dl($module);
	}
}

sub pmi_dl
{
	my $module = shift;

	my $BASE = "http://search.cpan.org";
	u("LWP::Simple", []);

	return if pmi_installed($module);

	$module =~ s/(\W)/"%" . unpack("H2", $1)/eg;
	my $html = LWP::Simple::get("$BASE/search?query=$module&mode=all");
	if ($html =~ m|<small>   <a href="([^"]+)">([^<]+)|)
	{
		my ($url, $name) = ($1, $2);

		print "Grabbing $name\n";
		return if pmi_installed($name);

		if (-e "$name.tar.gz")
		{
			print "File `$name.tar.gz` exists, no need to download\n";
			pmi_install("$name.tar.gz");
		}
		else
		{
			my $html2 = LWP::Simple::get($BASE . $1);
			if ($html2 =~ /href="([^"]+)">Download/)
			{
				my $url = $BASE . $1;
				print "Downloading $url\n";
				$url =~ m|/([^/]+)$|;
				my $file = $1;
				if (-e $file)
				{
					print "File `$file` exists, no need to download\n";
					pmi_install($file);
				}
				else
				{
					getstore($url, $file);
					pmi_install($file);
				}
			}
		}
	}
}

sub pmi_install
{
	my $file = shift;

	print "Unpacking $file\n";
	system("tar", "-zxf", $file);
	my $cd = $file;
	$cd =~ s/\.tar\.gz|\.tgz//;

	my $out = `cd $cd && perl Makefile.PL 2>&1`;
	print $out;
	while ($out =~ s/prerequisite (\S+) \S+ not found//)
	{
		print "INSTALLING PREREQUISITE: $1\n";
		pmi_dl($1);
	}
	system("cd $cd && perl Makefile.PL && make && sudo make install");
}

sub pmi_installed
{
	my $module = shift;
	$module =~ s/-\d+(\.\d+)?$//;

	if (!system("perl -M$module -e1 2>>/dev/null"))
	{
		print "$module already installed\n";
		return 1;
	}

	return 0;
}

# extract an item from an array if it exists, removing it from the array and returning it
# works on @ARGV by default
sub extract
{
  my ($array, $match) = @_ == 2 ? @_ : (\@ARGV, @_);

  my @matches;
  for my $i (0 .. $#{$array})
  {
    if (ref($match) eq "Regexp" ? $array->[$i] =~ $match : $array->[$i] eq $match)
    {
      push @matches, splice(@$array, $i, 1);
    }
  }
  return wantarray() ? @matches : $matches[0];
}

# math functions
use constant PI => 4 * atan2(1, 1);
sub pi { 355/113 }
sub asin { atan2($_[0], sqrt(1 - $_[0] * $_[0])) }
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }
sub tan { sin($_[0]) / cos($_[0])  }
sub log10 { log($_[0])/log(10) }

# verbose cd
sub cdv
{
  print STDERR "> cd $_[0]\n";
  return cd(@_);
}

# change dir
sub cd
{
  return chdir($_[0]);
}

# list all files
sub ls
{
  my ($dir, $recurse) = @_;
  my @files = <$dir/*>;
  map { push @files, ls($_, 1) } grep { -d } @files;
  return @files;
}

# list -> hash
sub h { return map { $_ => 1 } @_ }

# watch dir for new files
sub watch_dir
{
  my ($dir, $sleep) = @_;
  $sleep ||= 1;

  # track time so if we're watching in the past few seconds, we use old files
  my %files = time() - $_y{watch_dir_time} > 5 ? h ls($dir, 1) : %{$_{watch_dir_files}};
  %{$_{watch_dir_files}} = %files;
  $_y{watch_dir_time} = time();

  while (1)
  {
    my @new = grep { !$files{$_} } ls($dir, 1);
    return @new if @new;
    sleep($sleep);
  }
}

sub screenshot_path
{
  my @paths = grep -d, (
    env_path("screenshots", "screenshot"),
    "$ENV{HOME}/Screenshots",
    "$ENV{HOME}/Desktop/Screenshots",
    "$ENV{HOME}/Dropbox/Screenshots",
    "$ENV{HOME}/Desktop",
  );
  return wantarray ? @paths : $paths[0];
}

# get path of something from env variable, otherwise use default
sub env_path
{
  my @cmd = @_;
  my $nodefault = $cmd[-1] == 1 ? pop(@cmd) : 0;

  if (@cmd > 1)
  {
    my @paths = grep { env_path($_, 1) } @cmd;
    return wantarray ? @paths : $nodefault ? $paths[0] : $paths[0] || $cmd[0];
  }
  my $cmd = $cmd[0];

  return $ENV{"${cmd}_PATH"} || $ENV{lc($cmd) . "_PATH"} || $ENV{uc($cmd) . "_PATH"} || $nodefault ? undef : $cmd;
}

# is stdin piped in?
# useful for scripts that can be used in a pipeline
sub piped
{
  return !-t STDIN;
}

# reads line by line either from pipe, from files passed in as args, from strings passed in via -s, or strings passed in without -s (if strings are passed in without -s, first we check to see if there are files with those names)
sub opts_lines
{
  &opts_fors
}

# return options where we may pass in strings, files, or explicilty state strings with -s or files with -f
sub opts_fors
{
  # stdin piped in?
  if (piped())
  {
    print "pipe\n";
    return (<>);
  }
  else
  {
    my @ret;
    my %args;
    use Getopt::Long qw(:config bundling auto_help);
    # --strings (-s) means all further args are strings
    # --string (-S) means only following arg is a string
    # --files (-f) means all further args are files
    # --file (-F) means only following arg is a file
    GetOptions(\%args, 'string=S', 'file=F', 'files|strings=f@|s@');

    print Dumper(\%args);
    print Dumper(\@ARGV);

    # return row by row or string if file doesn't exist
    my @ret = (cors(@ARGV));
    print "ret: ", Dumper(\@ret);

  }
}

# return every line of file, or treat file as string if file doesn't exist
sub cors { &cat_or_string }
sub cat_or_string
{
  print "cors: @_\n";
  map { -e $_ ? cat($_) : $_ } @_;
}

# add new functions here   #
# XXX END OF NEW FUNCTIONS y.pm ###
# -samyk


1;





=head1 NAME

Parallel::ForkManager - A simple parallel processing fork manager

=head1 SYNOPSIS

  use Parallel::ForkManager;

  $pm = new Parallel::ForkManager($MAX_PROCESSES);

  foreach $data (@all_data) {
    # Forks and returns the pid for the child:
    my $pid = $pm->start and next; 

    ... do some work with $data in the child process ...

    $pm->finish; # Terminates the child process
  }

=head1 DESCRIPTION

This module is intended for use in operations that can be done in parallel 
where the number of processes to be forked off should be limited. Typical 
use is a downloader which will be retrieving hundreds/thousands of files.

The code for a downloader would look something like this:

  use LWP::Simple;
  use Parallel::ForkManager;

  ...
  
  @links=( 
    ["http://www.foo.bar/rulez.data","rulez_data.txt"], 
    ["http://new.host/more_data.doc","more_data.doc"],
    ...
  );

  ...

  # Max 30 processes for parallel download
  my $pm = new Parallel::ForkManager(30); 

  foreach my $linkarray (@links) {
    $pm->start and next; # do the fork

    my ($link,$fn) = @$linkarray;
    warn "Cannot get $fn from $link"
      if getstore($link,$fn) != RC_OK;

    $pm->finish; # do the exit in the child process
  }
  $pm->wait_all_children;

First you need to instantiate the ForkManager with the "new" constructor. 
You must specify the maximum number of processes to be created. If you 
specify 0, then NO fork will be done; this is good for debugging purposes.

Next, use $pm->start to do the fork. $pm returns 0 for the child process, 
and child pid for the parent process (see also L<perlfunc(1p)/fork()>). 
The "and next" skips the internal loop in the parent process. NOTE: 
$pm->start dies if the fork fails.

$pm->finish terminates the child process (assuming a fork was done in the 
"start").

NOTE: You cannot use $pm->start if you are already in the child process. 
If you want to manage another set of subprocesses in the child process, 
you must instantiate another Parallel::ForkManager object!

=head1 METHODS

=over 5

=item new $processes

Instantiate a new Parallel::ForkManager object. You must specify the maximum 
number of children to fork off. If you specify 0 (zero), then no children 
will be forked. This is intended for debugging purposes.

=item start [ $process_identifier ]

This method does the fork. It returns the pid of the child process for 
the parent, and 0 for the child process. If the $processes parameter 
for the constructor is 0 then, assuming you're in the child process, 
$pm->start simply returns 0.

An optional $process_identifier can be provided to this method... It is used by 
the "run_on_finish" callback (see CALLBACKS) for identifying the finished
process.

=item finish [ $exit_code ]

Closes the child process by exiting and accepts an optional exit code 
(default exit code is 0) which can be retrieved in the parent via callback. 
If you use the program in debug mode ($processes == 0), this method doesn't 
do anything.

=item set_max_procs $processes

Allows you to set a new maximum number of children to maintain. Returns 
the previous setting.

=item wait_all_children

You can call this method to wait for all the processes which have been 
forked. This is a blocking wait.

=back

=head1 CALLBACKS

You can define callbacks in the code, which are called on events like starting 
a process or upon finish.

The callbacks can be defined with the following methods:

=over 4

=item run_on_finish $code [, $pid ]

You can define a subroutine which is called when a child is terminated. It is
called in the parent process.

The paremeters of the $code are the following:

  - pid of the process, which is terminated
  - exit code of the program
  - identification of the process (if provided in the "start" method)
  - exit signal (0-127: signal name)
  - core dump (1 if there was core dump at exit)

=item run_on_start $code

You can define a subroutine which is called when a child is started. It called
after the successful startup of a child in the parent process.

The parameters of the $code are the following:

  - pid of the process which has been started
  - identification of the process (if provided in the "start" method)

=item run_on_wait $code, [$period]

You can define a subroutine which is called when the child process needs to wait
for the startup. If $period is not defined, then one call is done per
child. If $period is defined, then $code is called periodically and the
module waits for $period seconds betwen the two calls. Note, $period can be
fractional number also. The exact "$period seconds" is not guarranteed,
signals can shorten and the process scheduler can make it longer (on busy
systems).

The $code called in the "start" and the "wait_all_children" method also.

No parameters are passed to the $code on the call.

=back

=head1 EXAMPLE

=head2 Parallel get

This small example can be used to get URLs in parallel.

  use Parallel::ForkManager;
  use LWP::Simple;
  my $pm=new Parallel::ForkManager(10);
  for my $link (@ARGV) {
    $pm->start and next;
    my ($fn)= $link =~ /^.*\/(.*?)$/;
    if (!$fn) {
      warn "Cannot determine filename from $fn\n";
    } else {
      $0.=" ".$fn;
      print "Getting $fn from $link\n";
      my $rc=getstore($link,$fn);
      print "$link downloaded. response code: $rc\n";
    };
    $pm->finish;
  };

=head2 Callbacks

Example of a program using callbacks to get child exit codes:

  use strict;
  use Parallel::ForkManager;

  my $max_procs = 5;
  my @names = qw( Fred Jim Lily Steve Jessica Bob Dave Christine Rico Sara );
  # hash to resolve PID's back to child specific information

  my $pm =  new Parallel::ForkManager($max_procs);

  # Setup a callback for when a child finishes up so we can
  # get it's exit code
  $pm->run_on_finish(
    sub { my ($pid, $exit_code, $ident) = @_;
      print "** $ident just got out of the pool ".
        "with PID $pid and exit code: $exit_code\n";
    }
  );

  $pm->run_on_start(
    sub { my ($pid,$ident)=@_;
      print "** $ident started, pid: $pid\n";
    }
  );

  $pm->run_on_wait(
    sub {
      print "** Have to wait for one children ...\n"
    },
    0.5
  );

  foreach my $child ( 0 .. $#names ) {
    my $pid = $pm->start($names[$child]) and next;

    # This code is the child process
    print "This is $names[$child], Child number $child\n";
    sleep ( 2 * $child );
    print "$names[$child], Child $child is about to get out...\n";
    sleep 1;
    $pm->finish($child); # pass an exit code to finish
  }

  print "Waiting for Children...\n";
  $pm->wait_all_children;
  print "Everybody is out of the pool!\n";

=head1 BUGS AND LIMITATIONS

Do not use Parallel::ForkManager in an environment, where other child
processes can affect the run of the main program, so using this module
is not recommended in an environment where fork() / wait() is already used.

If you want to use more than one copies of the Parallel::ForkManager, then
you have to make sure that all children processes are terminated, before you
use the second object in the main program.

You are free to use a new copy of Parallel::ForkManager in the child
processes, although I don't think it makes sense.

=head1 COPYRIGHT

Copyright (c) 2000 Szabó, Balázs (dLux)

All right reserved. This program is free software; you can redistribute it 
and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

  dLux (Szabó, Balázs) <dlux@kapu.hu>

=head1 CREDITS

  Noah Robin <sitz@onastick.net> (documentation tweaks)
  Chuck Hirstius <chirstius@megapathdsl.net> (callback exit status, example)
  Grant Hopwood <hopwoodg@valero.com> (win32 port)
  Mark Southern <mark_southern@merck.com> (bugfix)

=cut

package Parallel::ForkManager;
use POSIX ":sys_wait_h";
use strict;
use vars qw($VERSION);
$VERSION='0.7.5';

sub new { my ($c,$processes)=@_;
  my $h={
    max_proc   => $processes,
    processes  => {},
    in_child   => 0,
  };
  return bless($h,ref($c)||$c);
};

sub start { my ($s,$identification)=@_;
  die "Cannot start another process while you are in the child process"
    if $s->{in_child};
  while ($s->{max_proc} && ( keys %{ $s->{processes} } ) >= $s->{max_proc}) {
    $s->on_wait;
    $s->wait_one_child(defined $s->{on_wait_period} ? &WNOHANG : undef);
  };
  $s->wait_children;
  if ($s->{max_proc}) {
    my $pid=fork();
    die "Cannot fork: $!" if !defined $pid;
    if ($pid) {
      $s->{processes}->{$pid}=$identification;
      $s->on_start($pid,$identification);
    } else {
      $s->{in_child}=1 if !$pid;
    }
    return $pid;
  } else {
    $s->{processes}->{$$}=$identification;
    $s->on_start($$,$identification);
    return 0; # Simulating the child which returns 0
  }
}

sub finish { my ($s, $x)=@_;
  if ( $s->{in_child} ) {
    exit ($x || 0);
  }
  if ($s->{max_proc} == 0) { # max_proc == 0
    $s->on_finish($$, $x ,$s->{processes}->{$$}, 0, 0);
    delete $s->{processes}->{$$};
  }
  return 0;
}

sub wait_children { my ($s)=@_;
  return if !keys %{$s->{processes}};
  my $kid;
  do {
    $kid = $s->wait_one_child(&WNOHANG);
  } while $kid > 0 || $kid < -1; # AS 5.6/Win32 returns negative PIDs
};

*wait_childs=*wait_children; # compatibility

sub wait_one_child { my ($s,$par)=@_;
  my $kid;
  while (1) {
    $kid = $s->_waitpid(-1,$par||=0);
    last if $kid == 0 || $kid == -1; # AS 5.6/Win32 returns negative PIDs
    redo if !exists $s->{processes}->{$kid};
    my $id = delete $s->{processes}->{$kid};
    $s->on_finish( $kid, $? >> 8 , $id, $? & 0x7f, $? & 0x80 ? 1 : 0);
    last;
  }
  $kid;
};

sub wait_all_children { my ($s)=@_;
  while (keys %{ $s->{processes} }) {
    $s->on_wait;
    $s->wait_one_child(defined $s->{on_wait_period} ? &WNOHANG : undef);
  };
}

*wait_all_childs=*wait_all_children; # compatibility;

sub run_on_finish { my ($s,$code,$pid)=@_;
  $s->{on_finish}->{$pid || 0}=$code;
}

sub on_finish { my ($s,$pid,@par)=@_;
  my $code=$s->{on_finish}->{$pid} || $s->{on_finish}->{0} or return 0;
  $code->($pid,@par); 
};

sub run_on_wait { my ($s,$code, $period)=@_;
  $s->{on_wait}=$code;
  $s->{on_wait_period} = $period;
}

sub on_wait { my ($s)=@_;
  if(ref($s->{on_wait}) eq 'CODE') {
    $s->{on_wait}->();
    if (defined $s->{on_wait_period}) {
        local $SIG{CHLD} = sub { } if ! defined $SIG{CHLD};
        select undef, undef, undef, $s->{on_wait_period}
    };
  };
};

sub run_on_start { my ($s,$code)=@_;
  $s->{on_start}=$code;
}

sub on_start { my ($s,@par)=@_;
  $s->{on_start}->(@par) if ref($s->{on_start}) eq 'CODE';
};

sub set_max_procs { my ($s, $mp)=@_;
  $s->{max_proc} = $mp;
}

# OS dependant code follows...

sub _waitpid { # Call waitpid() in the standard Unix fashion.
  return waitpid($_[1],$_[2]);
}

# On ActiveState Perl 5.6/Win32 build 625, waitpid(-1, &WNOHANG) always
# blocks unless an actual PID other than -1 is given.
sub _NT_waitpid { my ($s, $pid, $par) = @_;
  if ($par == &WNOHANG) { # Need to nonblock on each of our PIDs in the pool.
    my @pids = keys %{ $s->{processes} };
    # Simulate -1 (no processes awaiting cleanup.)
    return -1 unless scalar(@pids);
    # Check each PID in the pool.
    my $kid;
    foreach $pid (@pids) {
      $kid = waitpid($pid, $par);
      return $kid if $kid != 0; # AS 5.6/Win32 returns negative PIDs.
    }
    return $kid;
  } else { # Normal waitpid() call.
    return waitpid($pid, $par);
  }
}

{
  local $^W = 0;
  if ($^O eq 'NT' or $^O eq 'MSWin32') {
    *_waitpid = \&_NT_waitpid;
  }
}


=cut
end of Parallel::ForkManager
=cut

### XXX ###
## note this is a different package, please move new functions into the `y` package
## search for "NEW FUNCTIONS"
### XXX ###


1;
