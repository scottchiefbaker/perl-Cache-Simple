#!/usr/bin/perl

#use Data::Dump::Color;
use File::Find;
use Storable;
use Getopt::Long;
use strict;

my $remove  = 0;
my $verbose = 0;

my $ok = GetOptions(
	'remove'  => \$remove,
	'verbose' => \$verbose,
);

my $dir = $ARGV[0];
$dir ||= "/tmp/perl-cache/";

check_cache($dir);

###############################################################

sub check_cache {
	my $dir   = shift();
	my @files = ();

	# Code reference to be used by find()
	my $file_find = sub {
		my $dir  = $File::Find::dir;
		my $file = $_;
		my $path = $dir . "/" . $file;

		if (-f $path) {
			my $info    = get_cache_info($path);
			my $expired = is_expired($info);

			if ($expired) {
				print "$path is expired ($expired)\n";
				if ($remove) {
					my $ok = unlink($path);

					if (!$ok) {
						print "Error removing $path\n";
					}
				}
			} else {
				if ($verbose) {
					print "$path is not expired\n";
				}
			}
		}

	};

	$ok = find($file_find,$dir);
}

sub get_cache_info {
	my $file = shift();
	my $i    = retrieve($file);

	return $i;
}

sub is_expired {
	my $i = shift();

	if ($i->{expires} < time()) {
		return localtime($i->{expires});
	} else {
		#print localtime($i->{expires}) . "\n";
		return 0;
	}
}
