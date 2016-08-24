package PagerService::Controller::Root;
use Moose;
use namespace::autoclean;
use JSON;
use RedisDB;
use DateTime;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller::REST' }

__PACKAGE__->config(
    'default'   => 'text/html',
    'stash_key' => 'rest',
    'map'       => {
        'text/html'          => 'YAML::HTML',
        'text/xml'           => 'XML::Simple',
        'text/x-yaml'        => 'YAML',
        'application/json'   => 'JSON',
        'text/x-json'        => 'JSON',
    },
);

__PACKAGE__->config(namespace => '');

=head1 NAME

PagerService::Controller::Root - API Methods

=head1 AUTHOR

Alexandru Bagu <alexandru.bagu@webfusion.com>

=cut

sub messages    :Local : ActionClass('REST') { }
sub validate    :Local : ActionClass('REST') { }
sub register        :Local : ActionClass('REST') { }

my @skip_methods = qw(
    messages_POST
    messages_DELETE
    messages_PUT
    validate_POST
    validate_PUT
    validate_DELETE
    register_GET
    register_PUT
    register_DELETE    
);

my %CODES = (
    "BAD_METHOD"                    => 0,
    "METHOD_NOT_IMPLEMENTED"        => 1,
    "TOKEN_NOT_PROVIDED"            => 2,
    "TOKEN_NOT_FOUND"               => 3,
    "APPLICATION_KEY_NOT_FOUND"     => 4,
    "SUCCESS"                       => 5,
    "MESSAGE_ALREADY_CREATED"       => 6,
    "BAD_REQUEST"                   => 7,
);

sub begin :Private {
    my ($self, $c ) = @_;
    map {
        if ( $_ eq ( $c->request->action . '_' . $c->request->method ) ) {
            my $virtual_method = do { no strict 'refs'; \*{__PACKAGE__."::$_"} };
            *$virtual_method = sub {
               my ( $self, $c ) = @_;
               return $self->status_bad_request(
                   $c,
                   message => $CODES{METHOD_NOT_IMPLEMENTED},
               );          
            } if( not defined __PACKAGE__->can($_) )
        }
    } @skip_methods;
}

sub default :Path {
    my ( $self, $c ) = @_;
    $self->status_bad_request(
        $c,
        message => $CODES{BAD_METHOD}
    );
}

sub messages_GET {
    my ( $self, $c ) = @_;
    my $application_key = $c->request->param('application_key');
    my $date = $c->request->param('date');
    my $token = $c->request->param('token');

    if ( not defined $application_key ||
         not defined $date ||
         not defined $token ) 
    {
        return $self->status_bad_request(
            $c,
            message => $CODES{BAD_REQUEST},
        );
    }

    my $schema = $c->model('DB');
    my $client = $schema->resultset('Client')->search({
        application_key => $application_key,    
    })->first;

    my $dt = DateTime->now;
    $dt->set_time_zone( 'UTC' );
    my $now =  $dt->ymd('-') . ' ' . $dt->hms(':');

    if ( defined $client ) {
        my $device = $client->search_related('devices', {
            token => $token,
        })->first;
        if ( defined $device ) {
            my @data;
            my @messages;
            if( $date eq 'null' ) {
                my $last_message = $client->search_related('messages', {
                    processed       => 1,
                }, {
                    order_by        => { -desc => 'message_id' },
                })->first;
                push @messages, $last_message if $last_message;
            } else {
                print STDERR Dumper  {
                    processed       => 1,
                    processed_on    => {
                        '<' =>  $now,
                        '>' => $date,
                    }
                };

                @messages = $client->search_related('messages', {
                    processed       => 1,
                    processed_on    => {
                        '<' =>  $now,
                        '>' => $date,
                    }
                })->all;
            }

            foreach( @messages ) {
                my $processed_on = $_->processed_on;
                push @data, {
                    subject => $_->subject,
                    message => $_->message,
                    processed => $processed_on->ymd('-') . " " . $processed_on->hms(':'),
                };
            }

            my $json = JSON->new->allow_nonref;
            my $json_string = $json->encode( \@data );

            $c->log->info( Dumper $json_string );

            $c->response->headers->content_type('application/json');
            $c->response->body( $json_string );
        } else {
            return $self->status_bad_request(
                $c,
                message => $CODES{TOKEN_NOT_FOUND},
            );
        }
    } else {
        return $self->status_bad_request(
            $c,
            message => $CODES{APPLICATION_KEY_NOT_FOUND},
        );
    }
}

sub validate_GET {
    my ( $self, $c ) = @_;
    my $token = $c->req->arguments->[0];
    if( defined $token ) {
        my $redis = RedisDB->new(host => 'localhost', port => 6379);
        my $json_data = $redis->get( $token );
        if ( defined $json_data ) {
            my $json = JSON->new->allow_nonref; 
            my $json_obj = $json->decode( $json_data );

            my $schema = $c->model('DB');
            my $message = $schema->resultset('Message')->search({
                token => $token
            })->first;
            if ( defined $message ) {
                $c->response->body( 'Message was sent' );  
            } else {
                $schema->resultset('Message')->create({
                    subject     => $json_obj->{subject},
                    message     => $json_obj->{body},
                    receiver    => $json_obj->{from},
                    client_id   => $json_obj->{client_id},
                    token       => $token,
                });
                return $c->response->body( 'Message sent' );        
            }
        } else {
            return $self->status_bad_request(
                $c,
                message => $CODES{TOKEN_NOT_FOUND},
            );          
        }
    } else {
        return $self->status_bad_request(
            $c,
            message => $CODES{TOKEN_NOT_PROVIDED},
        );          
    }
}

sub register_POST {
    my ( $self, $c ) = @_;

    if( ref $c->request->body eq 'File::Temp' ) {
        local $/;

        open FD, $c->request->body->filename;
        my $json_content = <FD>;
        close FD;
        
        my $json = JSON->new;
        $json = $json->allow_nonref(1);
        my $json_object = $json->decode( $json_content );

        $c->log->info( Dumper $json_object );

        my @required_fileds = qw( application_key token platform );
        foreach( @required_fileds ) {
            return $self->status_bad_request(
                $c,
                message => "$_ is missing",
            ) unless ( $json_object->{$_} );
        }

        my $schema = $c->model('DB');
    
        my $client = $schema->resultset('Client')->search({
            application_key => $json_object->{application_key},
        })->first;
    
        if( $client ) {
                my $device_exits = $client->search_related('devices', {
                    token => $json_object->{token},
                })->first; 

                if ( defined $device_exits ) {
                    $c->log->info("DEVICE WITH TOKEN " . $json_object->{token} . " EXITS INTO DATABASE");
                } else {
                    $client->devices->create({
                        token => $json_object->{token},
                        platform => $json_object->{platform},
                    });

                    return $self->status_ok(
                        $c,
                        entity => {
                            message => $CODES{SUCCESS},
                        }
                    );
                } 
        } else {
            return $self->status_bad_request(
                $c,
                message => $CODES{APPLICATION_KEY_NOT_FOUND},
            );
        }
    } else {
        $self->status_bad_request(
            $c,
            message => $CODES{BAD_REQUEST},
        ); 
    }
}

__PACKAGE__->meta->make_immutable;

1;
