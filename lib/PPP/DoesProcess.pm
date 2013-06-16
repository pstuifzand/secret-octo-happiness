package PPP::DoesProcess;
use Moo::Role;

sub process {
    my ($self, $keyword, $name, $args, $block) = @_;
    my $method_name = 'process_'.$keyword;
    if (my $method = $self->can($method_name)) {
        $self->$method($name, $args, $block);
    }
    return;
}

1;
