defmodule CopperApi.Queries.Activity do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module is for getting activities out of the "Local Copper Postgres" when the collectors were working.
  """
  alias CopperApi.Schemas.Activity

  import Ecto.Query

  def by_copper_id(copper_id) do
    from(a in Activity, where: a.copper_id == ^copper_id)
    |> Activity.read()
  end
end
