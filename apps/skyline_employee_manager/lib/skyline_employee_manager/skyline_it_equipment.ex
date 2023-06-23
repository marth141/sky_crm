defmodule SkylineEmployeeManager.SkylineItEquipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skyline_it_equipment" do
    belongs_to(:skyline_employee, SkylineEmployeeManager.Employee, on_replace: :update)
    field(:type, :string)
    field(:cost, :integer)
    field(:store_link, :string)
    field(:purchase_receipt, :binary)
  end

  def changeset(skyline_employee, params \\ %{}) do
    skyline_employee
    |> cast(params, [:first_name, :last_name, :email_address, :department])
    |> validate_required([:first_name, :last_name, :email_address, :department])
  end

  def employee_assoc_changeset(equipment, employee, params \\ %{}) do
    equipment
    |> cast(params, [:type, :cost, :store_link, :purchase_receipt])
    |> validate_required([:type, :cost, :store_link, :purchase_receipt])
    |> put_assoc(:skyline_employee, employee)
  end
end
