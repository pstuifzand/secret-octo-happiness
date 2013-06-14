package PPP::Class;
use Moo;
use PPP::Attribute;

has name => (
    is => 'ro',
);

has _attributes => (
    is => 'ro',
    default => sub { +[] },
);

sub attributes {
    my $self = shift;
    return @{$self->_attributes};
}

sub add_attribute {
    my $self = shift;
    my ($attr) = @_;
    push @{$self->_attributes}, $attr;
}

1;
