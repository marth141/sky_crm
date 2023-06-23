defmodule Web.InventoryLiveTest do
  use Web.ConnCase

  import Phoenix.LiveViewTest

  alias InfoTech.InventoryTracker

  @create_attrs %{
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

  defp fixture(:inventory) do
    {:ok, inventory} = InventoryTracker.create_inventory(@create_attrs)
    inventory
  end

  defp create_inventory(_) do
    inventory = fixture(:inventory)
    %{inventory: inventory}
  end

  describe "Index" do
    setup [:create_inventory]

    test "lists all assets", %{conn: conn, inventory: inventory} do
      {:ok, _index_live, html} = live(conn, Routes.inventory_index_path(conn, :index))

      assert html =~ "Listing Assets"
      assert html =~ inventory.brand
    end

    test "saves new inventory", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.inventory_index_path(conn, :index))

      assert index_live |> element("a", "New Inventory") |> render_click() =~
               "New Inventory"

      assert_patch(index_live, Routes.inventory_index_path(conn, :new))

      assert index_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#inventory-form", inventory: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.inventory_index_path(conn, :index))

      assert html =~ "Inventory created successfully"
      assert html =~ "some brand"
    end

    test "updates inventory in listing", %{conn: conn, inventory: inventory} do
      {:ok, index_live, _html} = live(conn, Routes.inventory_index_path(conn, :index))

      assert index_live |> element("#inventory-#{inventory.id} a", "Edit") |> render_click() =~
               "Edit Inventory"

      assert_patch(index_live, Routes.inventory_index_path(conn, :edit, inventory))

      assert index_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#inventory-form", inventory: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.inventory_index_path(conn, :index))

      assert html =~ "Inventory updated successfully"
      assert html =~ "some updated brand"
    end

    test "deletes inventory in listing", %{conn: conn, inventory: inventory} do
      {:ok, index_live, _html} = live(conn, Routes.inventory_index_path(conn, :index))

      assert index_live |> element("#inventory-#{inventory.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#inventory-#{inventory.id}")
    end
  end

  describe "Show" do
    setup [:create_inventory]

    test "displays inventory", %{conn: conn, inventory: inventory} do
      {:ok, _show_live, html} = live(conn, Routes.inventory_show_path(conn, :show, inventory))

      assert html =~ "Show Inventory"
      assert html =~ inventory.brand
    end

    test "updates inventory within modal", %{conn: conn, inventory: inventory} do
      {:ok, show_live, _html} = live(conn, Routes.inventory_show_path(conn, :show, inventory))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Inventory"

      assert_patch(show_live, Routes.inventory_show_path(conn, :edit, inventory))

      assert show_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#inventory-form", inventory: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.inventory_show_path(conn, :show, inventory))

      assert html =~ "Inventory updated successfully"
      assert html =~ "some updated brand"
    end
  end
end
