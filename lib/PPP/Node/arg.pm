package PPP::Node::arg;
use strict;
use parent 'PPP::Node';

sub as_pair {
    my $self = shift;
    return [ $self->[0], $self->[2] ];
}

1;

