defmodule CopperApi.Queries.People do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module is for querying people stuff from copper
  """
  alias CopperApi.Schemas.People

  import Ecto.Query

  def by_copper_id(copper_id) do
    from(p in People, where: p.copper_id == ^copper_id)
    |> People.read()
  end

  def list_people_related_to_opportunity(primary_contact_id) do
    from(p in People,
      where: p.copper_id == ^primary_contact_id
    )
    |> People.read()
  end

  def count do
    from(t in People, select: count(t.id))
    |> People.read()
  end
end
