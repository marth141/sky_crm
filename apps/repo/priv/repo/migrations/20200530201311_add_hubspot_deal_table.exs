defmodule Repo.Migrations.AddHubspotDealTable do
  use Ecto.Migration

  def up do
    create table("hubspot_deals") do
      add(:archived, :boolean)
      add(:createdAt, :string)
      add(:hubspot_deal_id, :bigint)
      add(:hubspot_owner_id, :bigint)
      add(:properties, :map)
      add(:updatedAt, :string)
    end

    create unique_index(:hubspot_deals, [:hubspot_deal_id])
  end

  def down do
    drop table("hubspot_deals")
  end
end
