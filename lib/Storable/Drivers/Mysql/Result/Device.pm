use utf8;
package Storable::Drivers::Mysql::Result::Device;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Storable::Drivers::Mysql::Result::Device

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

=head1 TABLE: C<devices>

=cut

__PACKAGE__->table("devices");

=head1 ACCESSORS

=head2 device_id

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

=head2 platform

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=cut

__PACKAGE__->add_columns(
  "device_id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "client_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "token",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "platform",
  { data_type => "varchar", is_nullable => 0, size => 15 },
);

=head1 PRIMARY KEY

=over 4

=item * L</device_id>

=back

=cut

__PACKAGE__->set_primary_key("device_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<token>

=over 4

=item * L</token>

=back

=cut

__PACKAGE__->add_unique_constraint("token", ["token"]);

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
  { "foreign.device_id" => "self.device_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-25 09:51:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TGxfpkMKO4NDiY9qvBqE5A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
