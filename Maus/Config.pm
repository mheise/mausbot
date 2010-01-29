package Maus::Config;

use warnings;
use strict;
use Carp;

use JSON::XS;
use Path::Class;
use Hash::Merge qw(merge);

use base qw(Exporter);
our @EXPORT_OK = qw(get_config);

my ($config_json, $site_config_json, $config, $site_config);
eval {
        $config_json = file('config.json')->slurp;
        $config = decode_json($config_json);
} or do {
        croak "Couldn't parse config file: $@";
};

eval {
        $site_config_json = file('site_config.json')->slurp;
        $site_config = decode_json($site_config_json);
} or do {
        carp "Couldn't parse site config file: $@";
        $site_config = {};
};

Hash::Merge::set_behavior('RIGHT_PRECEDENT');
my %config = %{ merge($config, $site_config) };

sub get_config {
    my ($item) = @_;
    return $config{$item};
}

1;
