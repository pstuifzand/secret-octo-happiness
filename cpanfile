requires 'Marpa::R2', '2.058000';
requires 'Class::Load', '0.20';
requires 'mro', '1.07';
requires 'Moo', '1.002000';
requires 'Scalar::Util', '1.23';


on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Exception';
};
