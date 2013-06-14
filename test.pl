#!/usr/bin/env perl
use 5.10.0;
use Marpa::R2;
use PPP;
use Data::Dumper;
use Scalar::Util 'blessed';

use Class::Load 'load_class';

my $ppp = PPP->new;

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

for my $d ($ast->decls) {
    say $d->keyword->name;
    say $d->name->name;

    for my $d2 ($d->arguments) {
        say $d2;
    }

    for my $d2 ($d->block->decls) {
        say $d2->name->name;
    }

    print "\n";
}

