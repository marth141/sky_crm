defmodule Repo.Migrations.AddNetsuiteSalesAddersTable do
  use Ecto.Migration

  def up do
    create table("netsuite_sales_adders") do
      add(:netsuite_sales_adder_id, :string)
      add(:isInactive, :boolean)
      add(:name, :string)
      add(:scriptId, :string)
    end

    create unique_index(:netsuite_sales_adders, [:netsuite_sales_adder_id])
  end

  def down do
    drop table("netsuite_sales_adders")
  end
end
