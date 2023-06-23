defmodule Web.EmployeesLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    users = Repo.all(SkylineEmployeeManager.SkylineEmployee)

    {:ok,
     socket
     |> assign_current_user(session)
     |> assign(:users, users)}
  end

  @impl true
  def handle_event("remove-equipment", %{"equipment" => equipment_id}, socket) do
    new_equipment =
      socket.assigns.equipment
      |> Enum.reject(fn equipment -> "#{equipment.id}" == equipment_id end)

    _new_user = Map.update!(socket.assigns.user, :equipment, fn _equipment -> new_equipment end)

    {:noreply, socket |> assign(:equipment, new_equipment)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user =
      Repo.get_by!(SkylineEmployeeManager.SkylineEmployee, id: id) |> Repo.preload(:equipment)

    import Ecto.Query

    unassigned_equipment =
      Repo.all(
        from(e in SkylineEmployeeManager.SkylineItEquipment, where: is_nil(e.skyline_employee_id))
      )

    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, user)
    |> assign(:equipment, user.equipment)
    |> assign(:unassigned_equipment, unassigned_equipment)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %SkylineEmployeeManager.SkylineEmployee{} |> Repo.preload(:equipment))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end
end
