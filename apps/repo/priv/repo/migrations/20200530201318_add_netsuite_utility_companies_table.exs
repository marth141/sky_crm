defmodule Repo.Migrations.AddNetsuiteUtilityCompanyTable do
  use Ecto.Migration

  def up do
    create table("netsuite_utility_companies") do
      add(:created, :string)
      add(:custrecord_bb_utility_company_state, :string)
      add(:netsuite_utility_company_id, :string)
      add(:isinactive, :string)
      add(:lastmodified, :string)
      add(:links, {:array, :string})
      add(:name, :string)
      add(:owner, :string)
      add(:recordid, :string)
      add(:scriptid, :string)
    end

    create unique_index(:netsuite_utility_companies, [:netsuite_utility_company_id])
  end

  def down do
    drop table("netsuite_utility_companies")
  end
end
