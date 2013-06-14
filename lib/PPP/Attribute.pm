package PPP::Attribute;
use Moo;

has name => (
    is => 'rw',
);

has default => (
    is => 'rw',
);

sub process_default {
    my ($self, $class, $value) = @_;
    $self->default(ref($value->[0]) eq 'CODE' ? $value->[0]->() : $value->[0]);
    return;
}

1;
