use Test::More;
use PPP::Loader;

my $loader = PPP::Loader->new;
my $toplevel = $loader->load(<<"PPP");
class Test000 {}
PPP

my $class = $toplevel->find_class('Test000');
is(ref($class), 'PPP::Class');

done_testing;

