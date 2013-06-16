use Test::More;
use Test::Exception;
use PPP::Loader;

my $loader = PPP::Loader->new;
my $toplevel = $loader->load(<<'PPP');
class Test000 {
    has test1 (is => ro);
    has test2 (is => rw);
    has test3 (is => rw, default => 1);
}
PPP

my $class = $toplevel->find_class('Test000');
my $obj = $class->new(test1 => 10, test2 => 100);
is($obj->test1, 10);
is($obj->test2, 100);
is($obj->test3, 1);
dies_ok { $obj->test1(10) };
$obj->test2(99);
is($obj->test2, 99);
is($obj->test3, 1);
$obj->test3(5);
is($obj->test3, 5);

done_testing;

