package PPP::Attribute;
use Moo;

has name => (
    is => 'rw',
);

has default => (
    is => 'rw',
);

sub apply_arg {
    my ($self, $arg) = @_;
    if ($arg->[0] eq 'default') {
        $self->default(ref($arg->[1]) eq 'CODE' ? $arg->[1][0]->() : $arg->[1][0]);
    }
    return;
}

1;
