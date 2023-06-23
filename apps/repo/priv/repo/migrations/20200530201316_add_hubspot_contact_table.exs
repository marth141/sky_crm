defmodule Repo.Migrations.AddHubspotContactTable do
  use Ecto.Migration

  def up do
    create table("hubspot_contacts") do
      add(:archived, :boolean)
      add(:createdAt, :string)
      add(:hubspot_contact_id, :bigint)
      add(:properties, :map)
      add(:updatedAt, :string)
    end

    create unique_index(:hubspot_contacts, [:hubspot_contact_id])
  end

  def down do
    drop table("hubspot_contacts")
  end
end
