use utf8;
package Storable::Drivers::Mysql::Result::EmailList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Storable::Drivers::Mysql::Result::EmailList

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

=head1 TABLE: C<email_lists>

=cut

__PACKAGE__->table("email_lists");

=head1 ACCESSORS

=head2 email_list_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 client_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 host

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 port

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 use_ssl

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "email_list_id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "client_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "host",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "port",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "use_ssl",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</email_list_id>

=back

=cut

__PACKAGE__->set_primary_key("email_list_id");

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


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-25 09:51:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U3VkKPkYDzO6Qmfv0WFIzQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
