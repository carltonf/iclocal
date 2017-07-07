#!/usr/bin/perl
# Finds the files that have the same name, case insensitively,
# in the current directory and its subdirectories

use warnings;
use strict;
use File::Find;
use File::Spec;

my %files;
find(sub {
         my $path = $File::Find::name;
         my ($vol, $dirs, $name) = File::Spec->splitpath($path);
         push @{$files{lc $name}}, $path;
     }, '.');

my $failed;

foreach (values %files) {
    if (@$_ > 1) {
        # reserve the first one
        for my $i (1..(@$_-1)){
            print @$_[$i], "\n";
            unlink @$_[$i];
        }
        $failed++;
    }
}

print "no similarly named files found\n" unless $failed;

