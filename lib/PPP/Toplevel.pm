package PPP::Toplevel;
use 5.10.0;
use Moo;
use PPP::Class;

has _classes => (
    is => 'ro',
    default => sub { +{} },
);

sub classes {
    my $self = shift;
    return values %{$self->_classes};
};

sub use_keyword {
    my ($self, $keyword, $name, $args, $block) = @_;
    if ($keyword eq 'class') {
        $self->add_class($name, $args, $block);
    }
    return;
}

sub add_class {
    my ($self, $name, $args, $block) = @_;

    my $c = PPP::Class->new(name => $name);

    for my $decl ($block->decls) {
        $self->use_class_keyword(
            $c,
            $decl->keyword->name,
            $decl->name->name,
            $decl->arguments,
            $decl->block
        );
    }
    $self->_classes->{$name} = $c;
    return;
}

sub use_class_keyword {
    my ($self, $class, $keyword, $name, $args, $block) = @_;
    if ($keyword eq 'has') {
        my $attr = PPP::Attribute->new(name => $name);
        $class->add_attribute($attr);
    }
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

