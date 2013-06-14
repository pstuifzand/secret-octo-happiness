#!/usr/bin/env perl
use 5.10.0;
use lib 'lib';

use PPP::Loader;
use Data::Dumper;

my $loader = PPP::Loader->new;

my $toplevel = $loader->load(<<'PPP');
class Point {
    has $x (is => rw, default => 0);
    has $y (is => rw, default => 0);
}
class Point3d (extends => Point) {
    has $z (is => rw, default => 100);
}
class Person {
    has $name;
    has $age;
}
PPP

{
    my $class = $toplevel->find_class('Point');
    my $object = $class->_new(x => 10, y => 12);
    print Dumper($object);
}

{
    my $class = $toplevel->find_class('Point3d');
    my $object = $class->_new(x => 10, y => 12);
    print Dumper($object);
}

{
    my $class = $toplevel->find_class('Person');
    my $object = $class->_new(name => 'Peter', age => 29);
    print Dumper($object);
}
