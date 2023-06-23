defmodule Repo.Migrations.AddNetsuiteStateTable do
  use Ecto.Migration

  def up do
    create table("netsuite_states") do
      add(:created, :string)
      add(:custrecord_bb_state_country, :string)
      add(:custrecord_bb_state_full_name_text, :string)
      add(:netsuite_state_id, :string)
      add(:isinactive, :string)
      add(:lastmodified, :string)
      add(:links, {:array, :string})
      add(:name, :string)
      add(:owner, :string)
      add(:recordid, :string)
      add(:scriptid, :string)
    end

    create unique_index(:netsuite_states, [:netsuite_state_id])
  end

  def down do
    drop table("netsuite_states")
  end
end
