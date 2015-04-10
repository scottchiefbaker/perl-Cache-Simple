######################################################################
# Super simple disk based cached using only Perl core modules
######################################################################
# Scott Baker - 2015-04-07
#
# Similar concept to memcached: get/set/delete. For a more full
# featured Perl cache module, look at Cache::Cache. This was designed
# to be a single function, which be copy/pasted in to existing code
######################################################################

use cache;
use strict;

my $ok   = 0;
my $name = '';

# Store an item in the cache indefinitely
$ok = cache("name", "scott");

# Store an item in the cache for 60 seconds
$ok = cache("name", "scott", time() + 60);

# Fetch an item from the cache
$name = cache("name");

# Delete an item from the cache
$ok = cache("name",undef);
