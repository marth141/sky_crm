defmodule Repo.Migrations.AddSkylineItEquipmentTable do
  use Ecto.Migration

  def up do
    create table("skyline_it_equipment") do
      add(:skyline_employee_id, references(:skyline_employees))
      add(:type, :string)
      add(:cost, :bigint)
      add(:store_link, :string)
      add(:purchase_receipt, :binary)
    end
  end

  def down do
    drop table("skyline_it_equipment")
  end
end
