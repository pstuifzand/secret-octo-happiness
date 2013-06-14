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
class Point3d (extends => [Point]) {
    has $z (is => rw, default => 0);
}
class List {
    has @a (traits => [Array]);
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
    $scope->use_keyword($keyword, $name, $d->arguments, $d->block);
}

$scope->dump_classes;

