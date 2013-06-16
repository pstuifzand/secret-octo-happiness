use Test::More;
use Test::Exception;
use PPP::Loader;

my $loader = PPP::Loader->new;
my $toplevel = $loader->load(<<'PPP');
class Test000 {
    has test1 (is => ro);
}

class Test001 (extends => Test000) {
    has test2 (is => rw);
}
PPP

my $class = $toplevel->find_class('Test001');
my $obj = $class->new(test1 => 10, test2 => 100);
is($obj->test1, 10);
is($obj->test2, 100);
dies_ok { $obj->test1(10) };
$obj->test2(99);
is($obj->test2, 99);

done_testing;

