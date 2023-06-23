defmodule CopperApi.Queries.Groups do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module is for grouping some stuff.
  """
  alias CopperApi.Queries.Get

  def group_by_user(copper_list) do
    copper_list
    |> Enum.group_by(fn
      %{assignee_id: nil} -> "Unassigned"
      %{assignee_id: assignee_id} -> Get.copper_user_name_from_copper_id(assignee_id)
    end)
  end
end
