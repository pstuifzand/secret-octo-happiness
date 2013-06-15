package PPP::Loader;
use mro;
use Moo;

use PPP::Parser;
use PPP::Toplevel;
use Data::Dumper;
use Scalar::Util 'blessed';

use Class::Load 'load_class';

sub load {
    my ($self, $string) = @_;

    my $ppp = PPP::Parser->new;

    my $ast = $ppp->parse($string);

    $self->_load_classes($ast);
    load_class('PPP::Node::args');

    my $toplevel = PPP::Toplevel->new;
    my $scope = $toplevel;

    for my $d ($ast->decls) {
        my $keyword = $d->keyword->name;
        my $name    = $d->name->name;
        $scope->process($keyword, $name, $d->arguments->as_list, $d->block);
    }

    return $scope;
}

sub _load_classes {
    my $self = shift;
    my $ast = shift;

    my $class = blessed($ast);

    if ($class) {
        load_class($class);

        for (@$ast) {
            $self->_load_classes($_);
        }
    }
}

1;

