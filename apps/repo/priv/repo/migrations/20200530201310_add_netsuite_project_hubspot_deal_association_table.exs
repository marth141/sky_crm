defmodule Repo.Migrations.AddNetsuiteProjectHubspotDealAssociationTable do
  use Ecto.Migration

  def up do
    create table("netsuite_project_hubspot_deal_association_table") do
      add :netsuite_parent_customer_id, :bigint
      add :netsuite_sub_customer_id, :bigint
      add :netsuite_project_id, :bigint
      add :hubspot_contact_id, :bigint
      add :hubspot_deal_id, :bigint
      add :project_status, :string
      timestamps()
    end

    create unique_index(:netsuite_project_hubspot_deal_association_table, [:hubspot_deal_id])
  end

  def down do
    drop table("netsuite_project_hubspot_deal_association_table")
  end
end
