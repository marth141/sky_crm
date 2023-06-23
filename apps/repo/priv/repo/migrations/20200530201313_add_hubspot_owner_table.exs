defmodule Repo.Migrations.AddHubspotOwnerTable do
  use Ecto.Migration

  def up do
    create table("hubspot_owners") do
      add(:archived, :boolean)
      add(:createdAt, :string)
      add(:email, :string)
      add(:firstName, :string)
      add(:hubspot_owner_id, :bigint)
      add(:lastName, :string)
      add(:teams, {:array, :map})
      add(:updatedAt, :string)
      add(:userId, :integer)
    end

    create unique_index(:hubspot_owners, [:hubspot_owner_id])
  end

  def down do
    drop table("hubspot_owners")
  end
end
