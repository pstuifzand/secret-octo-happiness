package PPP::Class;
use Moo;
use PPP::Attribute;

has name => (
    is => 'ro',
);

has parent => (
    is        => 'rw',
    predicate => 1,
);

has _attributes => (
    is => 'ro',
    default => sub { +[] },
);

sub attributes {
    my $self = shift;
    my @a;
    push @a, @{$self->_attributes};
    if ($self->has_parent) {
        push @a, $self->parent->attributes;
    }
    return @a;
}

sub add_attribute {
    my $self = shift;
    my ($attr) = @_;
    push @{$self->_attributes}, $attr;
}

sub apply_arg {
    my ($self, $arg) = @_;

    if ($arg->[0] eq 'extends') {
        $self->parent($arg->[1]);
    }

    return;
}

sub process {
    my ($self, $keyword, $name, $args, $block) = @_;
    my $method = 'process_'.$keyword;
    $self->$method($name, $args, $block);
    return;
}

sub process_has {
    my ($self, $name, $args, $block) = @_;

    my $attr = PPP::Attribute->new(name => $name);

    if ($args) {
        my %attrs;
        for (@$args) {
            $attrs{$_->[0]}=1;
            my $method_name = 'process_'.$_->[0];
            if (my $method = $attr->can($method_name)) {
                $method->($attr, $self, $_->[1]);
            }
        }
        if (!$attrs{is}) {
            $attr->process_is($self, ['ro']);
        }
    }

    if ($block) {
        for my $decl ($block->decls) {
            $attr->process(
                $decl->keyword->name,
                $decl->name->name,
                $decl->arguments->as_list,
                $decl->block
            );
        }
    }

    $self->add_attribute($attr);

    return;
}

# In object
sub _new {
    my $self = shift;

    my (%args) = @_;

    my $obj = {};
    for my $attr ($self->attributes) {
        my $arg_name = $attr->external_name;
        $obj->{$attr->name} = $args{$arg_name} // $attr->default // 0;
    }
    return bless $obj, $self->name;
}

1;
