use utf8;
package Storable::Drivers::Mysql::Result::Client;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Storable::Drivers::Mysql::Result::Client

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

=head1 TABLE: C<clients>

=cut

__PACKAGE__->table("clients");

=head1 ACCESSORS

=head2 client_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 application_key

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "client_id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "application_key",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</client_id>

=back

=cut

__PACKAGE__->set_primary_key("client_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username", ["username"]);

=head1 RELATIONS

=head2 devices

Type: has_many

Related object: L<Storable::Drivers::Mysql::Result::Device>

=cut

__PACKAGE__->has_many(
  "devices",
  "Storable::Drivers::Mysql::Result::Device",
  { "foreign.client_id" => "self.client_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 email_lists

Type: has_many

Related object: L<Storable::Drivers::Mysql::Result::EmailList>

=cut

__PACKAGE__->has_many(
  "email_lists",
  "Storable::Drivers::Mysql::Result::EmailList",
  { "foreign.client_id" => "self.client_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages

Type: has_many

Related object: L<Storable::Drivers::Mysql::Result::Message>

=cut

__PACKAGE__->has_many(
  "messages",
  "Storable::Drivers::Mysql::Result::Message",
  { "foreign.client_id" => "self.client_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages_logs

Type: has_many

Related object: L<Storable::Drivers::Mysql::Result::MessagesLog>

=cut

__PACKAGE__->has_many(
  "messages_logs",
  "Storable::Drivers::Mysql::Result::MessagesLog",
  { "foreign.client_id" => "self.client_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-25 09:51:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MZBXdo0dAwU7eKk0gQgyPA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
