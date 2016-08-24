use utf8;
package Storable::Drivers::Mysql::Result::Message;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Storable::Drivers::Mysql::Result::Message

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<messages>

=cut

__PACKAGE__->table("messages");

=head1 ACCESSORS

=head2 message_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 client_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 subject

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 receiver

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 message

  data_type: 'tinytext'
  is_nullable: 0

=head2 validate_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 processed_on

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 processed

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=head2 sent

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "message_id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "client_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "token",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "subject",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "receiver",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "message",
  { data_type => "tinytext", is_nullable => 0 },
  "validate_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "processed_on",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "processed",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
  "sent",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</message_id>

=back

=cut

__PACKAGE__->set_primary_key("message_id");

=head1 RELATIONS

=head2 client

Type: belongs_to

Related object: L<Storable::Drivers::Mysql::Result::Client>

=cut

__PACKAGE__->belongs_to(
  "client",
  "Storable::Drivers::Mysql::Result::Client",
  { client_id => "client_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 messages_logs

Type: has_many

Related object: L<Storable::Drivers::Mysql::Result::MessagesLog>

=cut

__PACKAGE__->has_many(
  "messages_logs",
  "Storable::Drivers::Mysql::Result::MessagesLog",
  { "foreign.message_id" => "self.message_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-25 09:51:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mwmtSqDvWTptVHYOWRhDGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
