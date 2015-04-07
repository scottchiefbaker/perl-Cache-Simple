#!/usr/bin/perl

use Data::Dump::Color;
use Storable;
use strict;

my $file = $ARGV[0];

my $i = retrieve($file);

my $expires = $i->{expires};
my $key     = $i->{key};
my $date    = scalar(localtime($expires));

my $data    = $i->{data};

print "    Item Key : $key\n";
print "Item Expires : $date\n";
print "   Item Data :\n";
dd($data);
