package PPP::Attribute;
use Moo;
use Carp;

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

sub process_default {
    my ($self, $class, $value) = @_;
    $self->default(ref($value->[0]) eq 'CODE' ? $value->[0]->() : $value->[0]);
    return;
}

sub process_is {
    my ($self, $class, $value) = @_;
    $value = $value->[0];
    my $arg_name = $self->external_name;

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
