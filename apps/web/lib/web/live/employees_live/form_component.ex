defmodule Web.EmployeesLive.FormComponent do
  use Web, :live_component
  alias Phoenix.LiveView.JS

  @impl true
  def update(
        %{user: user, equipment: equipment, unassigned_equipment: unassigned_equipment} = assigns,
        socket
      ) do
    changeset = SkylineEmployeeManager.SkylineEmployee.changeset(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:equipment, equipment)
     |> assign(:unassigned_equipment, unassigned_equipment)}
  end

  @impl true
  def handle_event("validate", %{"skyline_employee" => user_params}, socket) do
    equipment =
      unless is_nil(user_params["equipment_to_add"]) do
        [
          socket.assigns.user.equipment
          | Enum.map(user_params["equipment_to_add"], fn
              id ->
                Repo.get_by!(SkylineEmployeeManager.SkylineItEquipment, id: id)
            end)
        ]
        |> List.flatten()
      else
        socket.assigns.user.equipment
      end

    changeset =
      socket.assigns.user
      |> SkylineEmployeeManager.SkylineEmployee.add_equipment_changeset(equipment, user_params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket, :changeset, changeset)
     |> assign(:equipment, equipment |> List.flatten())}
  end

  def handle_event("save", %{"skyline_employee" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case SkylineEmployeeManager.SkylineEmployee.update_user(
           socket.assigns.user,
           socket.assigns.equipment,
           user_params
         ) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case SkylineEmployeeManager.SkylineEmployee.create_user(user_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
