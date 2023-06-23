defmodule CopperApi.Queries do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  For just executing some query with Ecto.Repo
  """
  def execute_query(query) do
    Repo.all(query)
  end
end
