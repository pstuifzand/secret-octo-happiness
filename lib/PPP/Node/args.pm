package PPP::Node::args;
use strict;
use base 'PPP::Node';

sub as_list {
    my $self = shift;
    my @pairs;
    for (@$self) {
        push @pairs, $_->as_pair;
    }
    return \@pairs;
}


1;
