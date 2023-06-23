defmodule Repo.Migrations.AddNetsuiteLocationsTable do
  use Ecto.Migration

  def up do
    create table("netsuite_locations") do
      add(:netsuite_location_id, :string)
      add(:custrecord_bb_preferred_location, :string)
      add(:fullname, :string)
      add(:isinactive, :string)
      add(:lastmodifieddate, :string)
      add(:links, {:array, :string})
      add(:mainaddress, :string)
      add(:makeinventoryavailable, :string)
      add(:makeinventoryavailablestore, :string)
      add(:name, :string)
      add(:subsidiary, :string)
      add(:usebins, :string)
    end

    create unique_index(:netsuite_locations, [:netsuite_location_id])
  end

  def down do
    drop table("netsuite_locations")
  end
end
