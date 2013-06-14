package PPP::Parser;
use 5.10.0;
use Marpa::R2;

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;

    $self->{grammar} = Marpa::R2::Scanless::G->new({
        default_action => '::array',
        bless_package => 'PPP::Node',
        source => \<<'GRAMMAR',
:start   ::= program
:default ::= action => [values] bless => ::lhs

program  ::= decls

decls    ::= decl*

decl     ::= keyword name (';')
           | keyword name argument (';')
           | keyword name block
           | keyword name argument block
           | keyword block

keyword  ::=  ident

name     ::= ident | name_0
name_0     ~ '$' id
           | '@' id
           | '%' id

ident       ~ id
id          ~ id_0 id_1
id_0        ~ [a-zA-Z_]
id_1        ~ [a-zA-Z0-9_]*

block    ::= ('{') decls ('}')
argument ::= ('(') args (')')
args     ::= arg*              separator => comma proper => 0
arg      ::= ident '=>' value

value    ::= ident
           | number
           | '[' values ']'
values   ::= value*            separator => comma proper => 0

number     ~ [0-9]+

comma      ~ ','

:discard   ~ ws
ws         ~ [\s]+

GRAMMAR

    });

    return $self;
}

sub parse {
    my ($self, $input) = @_;
    my $re = Marpa::R2::Scanless::R->new({ grammar => $self->{grammar}});
    my $pos = $re->read(\$input);
    my $val = $re->value;
    return $$val;
}

1;
