package PPP::Toplevel;
use 5.10.0;
use Moo;
use PPP::Class;

with qw/
    PPP::DoesProcess
/;

has _classes => (
    is => 'ro',
    default => sub { +{} },
);

sub classes {
    my $self = shift;
    return values %{$self->_classes};
};

sub add_class {
    my ($self, $name, $args) = @_;
    mro::set_mro($name, 'c3');
    my $c = PPP::Class->new(name => $name);
    for (@$args) {
        if ($_->[0] eq 'extends') {
            ## Deref the name
            $c->apply_arg([ $_->[0], $self->_classes->{ $_->[1][0] } ]);
        }
    }
    return $c;
}

sub find_class {
    my $self = shift;
    my ($name) = @_;
    return $self->_classes->{$name};
}

sub process_class {
    my ($self, $name, $args, $block) = @_;

    my $c = $self->add_class($name, $args);

    for my $decl ($block->decls) {
        $c->process(
            $decl->keyword->name,
            $decl->name->name,
            $decl->arguments->as_list,
            $decl->block
        );
    }

    $c->process(
        'has', '$meta', [ ['is', ['ro'] ] ]
    );

    $self->_classes->{$name} = $c;

    return;
}

sub dump_classes {
    my $self = shift;
    for my $class ($self->classes) {
        say $class->name;
        say "\t" . $_->name for $class->attributes;
    }
}

1;

