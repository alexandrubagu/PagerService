#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;
use Mail::IMAPClient;
use IO::Socket::SSL;
use RedisDB;
use Data::UUID;

use lib '/home/abagu/git/MobileApps/backend/PagerService/lib';
use Storable::Drivers::Mysql;

sub sendEmail {
    my ($to, $from, $subject, $message) = @_;
    print STDERR "Sending mail to: $to using $from address and Subject: $subject\n";

    my $sendmail = '/usr/sbin/sendmail';
    open(MAIL, "|$sendmail -t");

    print MAIL "MIME-Version: 1.0\n";
    print MAIL "Content-Type: text/html; charset: utf8\n";
    print MAIL "Content-Disposition: inline\n";
    print MAIL "From: $from\n";
    print MAIL "To: $to\n";
    print MAIL "Subject: $subject\n\n";
    print MAIL "$message\n";

    close(MAIL);
}

sub read_json {
    my $file = shift;
    local $/;

    open FD, $file;
    my $json = JSON->new;
    $json->decode( <FD> );
}

my $db_config = read_json( '/home/abagu/git/MobileApps/backend/PagerService/config/database.json' );
my $schema = Storable::Drivers::Mysql->connect($db_config->{dsn} , $db_config->{user}, $db_config->{password});

my $redis = RedisDB->new(host => 'localhost', port => 6379);

my @clients = $schema->resultset('Client')->search({})->all;
foreach my $client ( @clients ) {
    my @email_lists = $client->email_lists;
    foreach my $email_list ( @email_lists ) {
        my $mail_client = Mail::IMAPClient->new(
            Server   => $email_list->host,
            User     => $email_list->username,
            Password => $email_list->password,
        ) or die "can't connect";
        
        if ( $mail_client->IsAuthenticated() ) {
            my @folders = $mail_client->folders();
            print Dumper \@folders;

            $mail_client->select('INBOX');

            my @unread = $mail_client->unseen;
            print Dumper \@unread;

            if( @unread ) {
                foreach ( @unread ) {
                    my $body = $mail_client->body_string( $_ );
                    chomp $body;
                    $body =~ s/\r//g;

                    my $from = $mail_client->get_header($_, "FROM");
                    $from =~ m/<(.*?)>/i;    
                    my $to = $1;

                    my $subject = $mail_client->get_header($_, "SUBJECT");

                    if( $body =~ /Content\-Type/ ) {
                        print "Please send a simple message\n";
                        sendEmail($to, $email_list->email, "Re: $subject", "Please send a simple message");
                    } elsif(  length( $body ) > 256 )  {
                        print "Your message is to long";
                        sendEmail($to, $email_list->email, "Re: $subject", "Your message is to long");
                    } else {
                        print STDERR "create token ... \n";
                        my $generator = new Data::UUID;
                        my $token = $generator->create_str();
                        print STDERR Dumper $token;
            

                        print STDERR "create json with details ... \n";
                        my $data = {
                            from        => $to,
                            subject     => $subject,
                            body        => $body,
                            client_id   => $client->client_id,
                        };
                        my $json  = JSON->new->allow_nonref;
                        my $json_data = $json->encode( $data );
                        print STDERR Dumper $data;

                        print STDERR "store to redis ... \n";
                        $redis->set( $token => $json_data);
                        $redis->expire( $token => 86400 );
                    
                        print STDERR "sending email ... \n";    
                        my $html_message = '
                            <html>
                                <head>
                                    <title>AppKind</title>
                                    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                                </head>
                                <body>
                                    <a href="http://cop-api-dev.ld4.webfusion.com:53189/validate/' . $token . '">Click here to validate</a>
                                </body>
                            </html>
                        ';
                        sendEmail($to, $email_list->email, "Re: $subject", $html_message);
                    }
                }
            } else {
                # no new email        
            }
            $mail_client->logout();
        }
    }
}
