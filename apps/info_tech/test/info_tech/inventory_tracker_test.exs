defmodule InfoTech.InventoryTrackerTest do
  use InfoTech.DataCase

  alias InfoTech.InventoryTracker

  describe "assets" do
    alias InfoTech.InventoryTracker.Inventory

    @valid_attrs %{
      brand: "some brand",
      check_in_date: ~N[2010-04-17 14:00:00],
      check_out_date: ~N[2010-04-17 14:00:00],
      model_number: "some model_number",
      serial_number: "some serial_number",
      type: "some type"
    }
    @update_attrs %{
      brand: "some updated brand",
      check_in_date: ~N[2011-05-18 15:01:01],
      check_out_date: ~N[2011-05-18 15:01:01],
      model_number: "some updated model_number",
      serial_number: "some updated serial_number",
      type: "some updated type"
    }
    @invalid_attrs %{
      brand: nil,
      check_in_date: nil,
      check_out_date: nil,
      model_number: nil,
      serial_number: nil,
      type: nil
    }

    def inventory_fixture(attrs \\ %{}) do
      {:ok, inventory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> InventoryTracker.create_inventory()

      inventory
    end

    test "list_assets/0 returns all assets" do
      inventory = inventory_fixture()
      assert InventoryTracker.list_assets() == [inventory]
    end

    test "get_inventory!/1 returns the inventory with given id" do
      inventory = inventory_fixture()
      assert InventoryTracker.get_inventory!(inventory.id) == inventory
    end

    test "create_inventory/1 with valid data creates a inventory" do
      assert {:ok, %Inventory{} = inventory} = InventoryTracker.create_inventory(@valid_attrs)
      assert inventory.brand == "some brand"
      assert inventory.check_in_date == ~N[2010-04-17 14:00:00]
      assert inventory.check_out_date == ~N[2010-04-17 14:00:00]
      assert inventory.model_number == "some model_number"
      assert inventory.serial_number == "some serial_number"
      assert inventory.type == "some type"
    end

    test "create_inventory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InventoryTracker.create_inventory(@invalid_attrs)
    end

    test "update_inventory/2 with valid data updates the inventory" do
      inventory = inventory_fixture()

      assert {:ok, %Inventory{} = inventory} =
               InventoryTracker.update_inventory(inventory, @update_attrs)

      assert inventory.brand == "some updated brand"
      assert inventory.check_in_date == ~N[2011-05-18 15:01:01]
      assert inventory.check_out_date == ~N[2011-05-18 15:01:01]
      assert inventory.model_number == "some updated model_number"
      assert inventory.serial_number == "some updated serial_number"
      assert inventory.type == "some updated type"
    end

    test "update_inventory/2 with invalid data returns error changeset" do
      inventory = inventory_fixture()

      assert {:error, %Ecto.Changeset{}} =
               InventoryTracker.update_inventory(inventory, @invalid_attrs)

      assert inventory == InventoryTracker.get_inventory!(inventory.id)
    end

    test "delete_inventory/1 deletes the inventory" do
      inventory = inventory_fixture()
      assert {:ok, %Inventory{}} = InventoryTracker.delete_inventory(inventory)
      assert_raise Ecto.NoResultsError, fn -> InventoryTracker.get_inventory!(inventory.id) end
    end

    test "change_inventory/1 returns a inventory changeset" do
      inventory = inventory_fixture()
      assert %Ecto.Changeset{} = InventoryTracker.change_inventory(inventory)
    end
  end
end
