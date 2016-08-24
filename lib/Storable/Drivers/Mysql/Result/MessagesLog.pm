use utf8;
package Storable::Drivers::Mysql::Result::MessagesLog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Storable::Drivers::Mysql::Result::MessagesLog

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

=head1 TABLE: C<messages_log>

=cut

__PACKAGE__->table("messages_log");

=head1 ACCESSORS

=head2 client_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 device_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 message_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 processed

  data_type: 'tinyint'
  is_nullable: 0

=head2 send_on

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "client_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "device_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "message_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "processed",
  { data_type => "tinyint", is_nullable => 0 },
  "send_on",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
);

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

=head2 device

Type: belongs_to

Related object: L<Storable::Drivers::Mysql::Result::Device>

=cut

__PACKAGE__->belongs_to(
  "device",
  "Storable::Drivers::Mysql::Result::Device",
  { device_id => "device_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 message

Type: belongs_to

Related object: L<Storable::Drivers::Mysql::Result::Message>

=cut

__PACKAGE__->belongs_to(
  "message",
  "Storable::Drivers::Mysql::Result::Message",
  { message_id => "message_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-25 09:51:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5EW+H4fIGiyL36sfKBGrGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
