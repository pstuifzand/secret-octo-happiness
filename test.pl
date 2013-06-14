#!/usr/bin/env perl
use 5.10.0;
use lib 'lib';
use Marpa::R2;
use PPP::Parser;
use PPP::Toplevel;
use Data::Dumper;
use Scalar::Util 'blessed';

use Class::Load 'load_class';

my $ppp = PPP::Parser->new;

my $ast = $ppp->parse(<<'PPP');
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

#print Dumper($ast);
load_classes($ast);

sub load_classes {
    my $self = shift;

    my $class = blessed($self);
    if ($class) {
        load_class($class);
    }

    for (@$self) {
        load_classes($_);
    }
}

my $toplevel = PPP::Toplevel->new;
my $scope = $toplevel;

for my $d ($ast->decls) {
    my $keyword = $d->keyword->name;
    my $name    = $d->name->name;
    $scope->process($keyword, $name, $d->arguments->as_list, $d->block);
}

$scope->dump_classes;

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
