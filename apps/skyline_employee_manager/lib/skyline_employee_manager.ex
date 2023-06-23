defmodule SkylineEmployeeManager do
  @moduledoc """
  Documentation for `SkylineEmployeeManager`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SkylineEmployeeManager.hello()
      :world

  """
  def hello do
    :world
  end

  def add_employee(%SkylineEmployeeManager.SkylineEmployee{} = arg) do
    Repo.insert!(arg)
  end

  def hire_employee_buy_equipment() do
    # Make an employee
    employee =
      %SkylineEmployeeManager.SkylineEmployee{
        first_name: "nate",
        last_name: "casados",
        email: "@org",
        department: "Information Technology"
      }
      |> Repo.insert!()

    # Buy some equipment
    equipment_1 =
      %SkylineEmployeeManager.SkylineItEquipment{
        type: "Desktop",
        cost: 700,
        store_link: "http://mystore.com",
        purchase_receipt: "receipt.pdf"
      }
      |> Repo.insert!()

    equipment_2 =
      %SkylineEmployeeManager.SkylineItEquipment{
        type: "Monitor",
        cost: 100,
        store_link: "http://mystore.com",
        purchase_receipt: "receipt.pdf"
      }
      |> Repo.insert!()

    {:ok, employee, equipment_1, equipment_2}
  end

  def add_equipment_to_employee(employee, equipment) do
    employee =
      SkylineEmployeeManager.SkylineEmployee.add_equipment_changeset(employee, equipment)
      |> Repo.update!()

    {:ok, employee}
  end

  def update_equipment_list_on_employee(employee, equipment) do
    employee =
      SkylineEmployeeManager.SkylineEmployee.update_equipment_changeset(employee, [equipment])
      |> Repo.update!()

    {:ok, employee}
  end

  def remove_equipment_from_employee(employee) do
    employee =
      SkylineEmployeeManager.SkylineEmployee.remove_equipment_changeset(employee)
      |> Repo.update!()

    {:ok, employee}
  end

  def get_employee(id) do
    Repo.get!(SkylineEmployeeManager.SkylineEmployee, id)
    |> Repo.preload(:equipment)
  end

  def get_employee do
    Repo.get!(SkylineEmployeeManager.SkylineEmployee, 1)
    |> Repo.preload(:equipment)
  end

  def get_equipment(id) do
    Repo.get!(SkylineEmployeeManager.SkylineItEquipment, id)
    |> Repo.preload(:skyline_employee)
  end

  def get_equipment do
    Repo.get!(SkylineEmployeeManager.SkylineItEquipment, 1)
    |> Repo.preload(:skyline_employee)
  end
end
