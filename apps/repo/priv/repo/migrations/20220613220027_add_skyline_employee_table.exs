defmodule Repo.Migrations.AddSkylineEmployeeTable do
  use Ecto.Migration

  def up do
    create table("skyline_employees") do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:department, :string)
    end

    create unique_index(:skyline_employees, [:email])
  end

  def down do
    drop table("skyline_employees")
  end
end
