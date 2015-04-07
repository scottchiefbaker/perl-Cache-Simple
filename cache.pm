sub cache {
	my ($key,$value,$time) = @_;

	use Storable;
	use Digest::MD5 qw(md5_hex);
	use File::Path qw(make_path);

	my $file = md5_hex($key);                          # Hash keys for directory load balancing
	my $path = "/tmp/perl-cache/" . substr($file,0,3); # 4096 cache dirs

	if ($key && @_ == 1) {                                                         # ** Get **
		if (!-r "$path/$file") { return undef; }                                   # Not on disk
		my $i = retrieve("$path/$file");                                           # Fetch the cache from disk
		if ($i->{'expires'} < time()) { cache($key,''); }                          # Expired, delete the file
		else { return $i->{'data'};	}                                              # Return the data structure
	} elsif ($key && $value) {                                                     # ** Set **
		my $time = $time || (time + 86400);                                        # Default expiration
		make_path($path);                                                          # Build the cache dir
		return store({'key'=>$key,'expires'=>$time,'data'=>$value},"$path/$file"); # Store on disk
	} elsif ($key && !defined($value)) {                                           # ** Delete **
		return unlink("$path/$file");                                              # Remove cache from disk
	}
}

1;
