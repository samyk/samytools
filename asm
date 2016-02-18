#!/usr/bin/perl

die "usage: $0 <file.asm>\ncompiles, links and executes .asm file via `nasm`\n" unless @ARGV;
my $asm = shift;
my $file = $asm;
$file =~ s/\.\w+$//;

system("/opt/local/bin/nasm", "-f", "macho", $asm);
system("ld", "-macosx_version_min", "10.7.0", "-o", $file, "$file.o");
system("./$file");