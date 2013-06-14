package PPP::Node::keyword;
use strict;
use base 'PPP::Node';

sub name {
    my $self = shift;
    return $self->[0];
}
1;
