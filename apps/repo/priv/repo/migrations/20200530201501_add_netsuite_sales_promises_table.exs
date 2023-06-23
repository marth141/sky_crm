defmodule Repo.Migrations.AddNetsuiteSalesPromisesTable do
  use Ecto.Migration

  def up do
    create table("netsuite_sales_promises") do
      add(:netsuite_sales_promise_id, :string)
      add(:isInactive, :boolean)
      add(:name, :string)
      add(:scriptId, :string)
    end

    create unique_index(:netsuite_sales_promises, [:netsuite_sales_promise_id])
  end

  def down do
    drop table("netsuite_sales_promises")
  end
end
