package PPP::Node::program;
use strict;
use base 'PPP::Node';

sub decls {
    my $self = shift;
    return @{$self->[0]};
}

1;
