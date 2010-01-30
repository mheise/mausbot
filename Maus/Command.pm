package Maus::Command;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use MooseX::ClassAttribute;

subtype 'IRC_Str'
    => as 'Str'
    => where { $_ !~ /1nj3ct|startkeylogger|\0|\x01/ }
    => message {"Can't say that on irc, sorry broseidon!"}
;

subtype 'CommandStr'
    => as 'IRC_Str'
    => where { /^\w+$/ }
    => message {"Commands can't have non-word chars, sorry bro!"}
;

has 'name' => (isa => 'CommandStr', is => 'ro', required => 1);
has 'help_text' => (isa => 'IRC_Str', is => 'ro', required => 1);
has 'func' => (isa => 'CodeRef', is => 'ro', required => 1_;
has 'aliases' => (isa => 'ArrayRef[CommandStr]', is => 'ro', required => 0);
