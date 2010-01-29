package Maus::Config;

use warnings;
use strict;
use Carp;

use JSON::XS;
use Path::Class;
use Hash::Merge qw(merge);

use base qw(Exporter);
our @EXPORT_OK = qw(get_config);

my $main_config_json = file('config.json')->slurp
	or croak "Couldn't open config file: $!";
my $main_config = decode_json($config_json);

my $site_config_json = file('site_config.json')->slurp
	or carp "Couldn't open site config file: $!";
my $site_config = decode_json($site_config_json);

Hash::Merge::set_behavior('RIGHT_PRECEDENT');
my %config = %{ merge($main_config, $site_config) };

sub get_config {
	my ($item) = @_;
	return $config{$item};
}

1;
