package PPP::Node::decl;
use strict;
use base 'PPP::Node';

sub keyword {
    my $self = shift;
    return $self->[0];
}

sub name {
    my $self = shift;
    return $self->[1];
}

sub arguments {
    my $self = shift;
    return $self->[2][0] if $self->[2]->isa('PPP::Node::argument');
}

sub block {
    my $self = shift;
    return $self->[2] if $self->[2]->isa('PPP::Node::block');
    return $self->[3] if $self->[3]->isa('PPP::Node::block');
}

1;

