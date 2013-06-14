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
        for (@$args) {
            $attr->apply_arg($_);
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
    for ($self->attributes) {
        my $arg_name = $_->name;
        $arg_name =~ s/^\$//;
        $obj->{$_->name} = $args{$arg_name} // $_->default // 0;
    }
    return bless $obj, $self->name;
}

1;
