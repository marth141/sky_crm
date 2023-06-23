defmodule SkylineEmployeeManagerTest do
  use ExUnit.Case
  doctest SkylineEmployeeManager

  test "greets the world" do
    assert SkylineEmployeeManager.hello() == :world
  end

  test "add equipment to employee" do
    {:ok, employee, equipment_1, equipment_2} =
      SkylineEmployeeManager.hire_employee_buy_equipment()

    SkylineEmployeeManager.add_equipment_to_employee(employee, [equipment_1, equipment_2])

    Repo.get!(SkylineEmployeeManager.Employee, employee.id)
    |> Repo.preload(:equipment)
    |> IO.inspect(label: "Test 1")
  end

  test "remove one equipment from employee" do
    {:ok, employee, equipment_1, equipment_2} =
      SkylineEmployeeManager.hire_employee_buy_equipment()

    SkylineEmployeeManager.add_equipment_to_employee(employee, [equipment_1, equipment_2])

    employee =
      Repo.get!(SkylineEmployeeManager.Employee, employee.id)
      |> Repo.preload(:equipment)

    SkylineEmployeeManager.update_equipment_list_on_employee(employee, equipment_1)
    |> IO.inspect(label: "Test 2")
  end

  test "remove all equipment from employee" do
    {:ok, employee, equipment_1, equipment_2} =
      SkylineEmployeeManager.hire_employee_buy_equipment()

    SkylineEmployeeManager.add_equipment_to_employee(employee, [equipment_1, equipment_2])

    employee =
      Repo.get!(SkylineEmployeeManager.Employee, employee.id)
      |> Repo.preload(:equipment)

    SkylineEmployeeManager.remove_equipment_from_employee(employee)
    |> IO.inspect(label: "Test 3")
  end
end
