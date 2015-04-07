use cache;
use Data::Dump::Color;
use Test::Simple tests => 13;

my $data = { 'foo' => 'bar', 'phone' => {'cell' => 1234, 'home' => 'yeah' }};

ok( cache("foo","bar") > 0, 'Basic set' ); # Set
ok( cache("foo") eq 'bar', 'Basic get' ); # Get

ok( cache("foo",$data) > 0, 'Complex set' ); # Set

ok( cache("","bar") == "", 'Invalid key' ); # Set
ok( cache() == "",'No options' ); # Set

ok( cache("foo","bar", time() + 10) > 0, 'Set with expire' ); # Set with expire
ok( cache("foo") eq 'bar', 'Get with expire time' ); # Get

ok( cache("foo","bar", time() - 10) > 0, 'Set with already expired time' ); # Set with expired time
ok( cache("foo") eq undef, 'Get with already expired time' ); # Get

ok( cache("foo","bar","invalid"), 'Set with invalid expire time value' ); # Set with invalid time
ok( cache("foo") eq undef, 'Get an invalid value' ); # Get

ok( cache("foo",undef) > 0, 'Basic delete' ); # Delete
ok( cache("foo",undef) == 0, "Delete an entry that doesn't exist" ); # Delete a missing entry
