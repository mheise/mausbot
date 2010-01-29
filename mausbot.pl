#!/usr/bin/env perl
# mausbot - a perl irc bot
# Copyright (c) 2010 Mike Heise
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
use warnings;
use strict;

use POE qw(Component::IRC::State Component::IRC::Plugin::AutoJoin
            Component::IRC::Plugin::Logger Component::IRC::Plugin::Connector);
use Maus::Config qw(get_config);

#timestamps are nice for long-running things like this
$SIG{'__WARN__'} = sub {warn scalar localtime().$".shift};

POE::Session->create(
    package_states => [
        main => [ qw(_start ), handled_events()]
    ]
);
$poe_kernel->run();

sub _start {
    my $irc = POE::Component::IRC::State->spawn(
        Nick   => get_config('nick'),
        Server => get_config('server'),
        Port   => get_config('port'),
        UseSSL => get_config('ssl'),
        Ircname=> get_config('ircname'),
    );
    $irc->plugin_add('Connector', POE::Component::IRC::Plugin::Connector->new(
            delay => get_config('ping_freq'),
            reconnect => get_config('reconnect_timeout'),
    ));
    $irc->plugin_add('AutoJoin', POE::Component::IRC::Plugin::AutoJoin->new(
            Channels => \@{get_config('channels')},
            RejoinOnKick => get_config('rejoin_on_kick'),
            Rejoin_delay => get_config('rejoin_delay_kick'),
            Retry_when_banned => get_config('rejoin_delay_ban'),
    ));
    $irc->plugin_add('Logger', POE::Component::IRC::Plugin::Logger->new(
            Path    => get_config('log_path'),
            Private => get_config('log_public_msgs'),
            Public  => get_config('log_private_msgs'),
    ));

    $irc->yield(register => 'all');
    $irc->yield('connect');
    $irc->yield(privmsg => 'NickServ', 'IDENTIFY '.get_config('pass'));
    $irc->yield(mode => get_config('nick').' +B');
    warn "mausbot: connected successfully\n";
}
