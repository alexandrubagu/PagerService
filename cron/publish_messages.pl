#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;
use RedisDB;
use Data::UUID;
use DateTime;
use WWW::Google::Cloud::Messaging;
use Net::APNS;

use lib '/home/abagu/git/MobileApps/backend/PagerService/lib';
use Storable::Drivers::Mysql;

sub read_json {
    my $file = shift;
    local $/;

    open FD, $file;
    my $json = JSON->new;
    $json->decode( <FD> );
}

my $db_config = read_json( '/home/abagu/git/MobileApps/backend/PagerService/config/database.json' );
my $schema = Storable::Drivers::Mysql->connect($db_config->{dsn} , $db_config->{user}, $db_config->{password});

my @messages = $schema->resultset('Message')->search({
    'processed' => 0
})->all;

foreach my $message ( @messages ) {
    my $body = $message->subject;

    print STDERR "sending message with body: $body\n";

    my $client = $message->client;
    my @devices = $client->devices;
    foreach my $device ( @devices ) {
        if( $device->platform eq 'android' ) {
            my $android_config = read_json('/home/abagu/git/MobileApps/backend/PagerService/keys/' . $client->username . "/android.json");
            my $gcm = WWW::Google::Cloud::Messaging->new(api_key => $android_config->{key});
            my $result = $gcm->send({
                registration_ids => [ $device->token ],
                data => {
                    message => $body,
                },
            });
            print  $result->error unless $result->is_success;
            print "android - ok\n";
        } elsif( $device->platform eq 'iphone' ) {
            my $iphone_config = read_json('/home/abagu/git/MobileApps/backend/PagerService/keys/' . $client->username . "/iphone.json");
            my $APNS = Net::APNS->new;
            my $path = '/home/abagu/git/MobileApps/backend/PagerService/keys/' . $client->username . "/";

            my $Notifier = $APNS->notify({
                cert   => $path . "cert.pem",
                key    => $path . "key.pem",
                passwd => $iphone_config->{password}
            });

            $Notifier->devicetoken( $device->token );
            $Notifier->sandbox(1);
            $Notifier->message($body);
            $Notifier->badge(1);
            $Notifier->sound('default');
            $Notifier->write;
            print Dumper $Notifier;
            print "iphone - ok\n";
        } elsif( $device->platform eq 'windows' ) {
        }
    }

    my $dt = DateTime->now;
    $dt->set_time_zone( 'UTC' );
    my $sent_on =  $dt->ymd('-') . 'T' . $dt->hms(':');
    $message->update({
        processed_on => $sent_on,
        processed  => 1,
    });
}
