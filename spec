#!/usr/bin/perl

my @defaults = qw/-F -s 20M/;
# spectrum analyzer (gpu accelerated)
system("osmocom_fft", @defaults, @ARGV);