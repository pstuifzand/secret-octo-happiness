package PPP::Node::decl;
use strict;
use base 'PPP::Node';
use PPP::Node::args;
use PPP::Node::argument;
use PPP::Node::block;

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
    return $self->[2][0] if $self->[2] && $self->[2]->isa('PPP::Node::argument');
    return bless [], 'PPP::Node::args';
}

sub block {
    my $self = shift;
    return $self->[2] if $self->[2] && $self->[2]->isa('PPP::Node::block');
    return $self->[3] if $self->[3] && $self->[3]->isa('PPP::Node::block');
}

1;

