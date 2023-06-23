defmodule Repo.Migrations.AddNetsuiteLeadSourcesTable do
  use Ecto.Migration

  def up do
    create table("netsuite_lead_sources") do
      add(:netsuite_lead_source_id, :string)
      add(:isinactive, :string)
      add(:links, {:array, :string})
      add(:name, :string)
      add(:recordid, :string)
      add(:scriptid, :string)
      timestamps()
    end

    create unique_index(:netsuite_lead_sources, [:netsuite_lead_source_id])
  end

  def down do
    drop table("netsuite_lead_sources")
  end
end
