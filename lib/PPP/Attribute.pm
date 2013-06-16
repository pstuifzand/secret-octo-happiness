package PPP::Attribute;
use Moo;
use Carp;

with qw/
    PPP::DoesProcess
/;

has parent => (
    is => 'ro',
);

has name => (
    is => 'rw',
);

has default => (
    is => 'rw',
);

has external_name => (
    is => 'lazy',
);

sub _build_external_name {
    my $self = shift;
    my $name = $self->name;
    $name =~ s/^\$//;
    return $name;
}

sub apply_arg {
    my ($self, $name, $value) = @_;

    if (my $method = $self->can('apply_arg_'.$name)) {
        $self->$method($value);
    }
    else {
        die "Can't apply $name to " . $self->name . " in " . $self->parent->name;
    }
    return;
}

sub apply_arg_default {
    my ($self, $value) = @_;
    $self->default(ref($value->[0]) eq 'CODE' ? $value->[0]->() : $value->[0]);
    return;
}

sub apply_arg_is {
    my ($self, $value) = @_;
    $value = $value->[0];
    my $arg_name = $self->external_name;
    my $class = $self->parent;

    if ($value eq 'ro') {
        no strict 'refs';
        *{ $class->name . '::' . $arg_name } = sub {
            my $that = shift;
            if (@_) {
                my $class_name = $class->name;
                croak "Attribute $arg_name is read-only in class $class_name";
            }
            return $that->{$self->name};
        };
    }
    elsif ($value eq 'rw') {
        no strict 'refs';
        *{ $class->name . '::' . $arg_name } = sub {
            my $that = shift;
            if (@_) {
                $that->{$self->name} = $_[0];
            }
            return $that->{$self->name};
        };
    }
    return;
}

1;
