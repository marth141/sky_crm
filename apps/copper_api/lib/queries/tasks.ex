defmodule CopperApi.Queries.Tasks do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module was for querying tasks from Copper
  """
  alias CopperApi.Schemas.Task
  alias CopperApi.Queries.Get

  import Ecto.Query

  def by_copper_id(copper_id) do
    from(t in Task, where: t.copper_id == ^copper_id)
    |> Task.read()
  end

  # TODO Still testing
  def by_emails() do
    from(t in Task, where: t.custom_activity_type_id == ^Get.activity_type_id_by_name("Note"))
    |> Task.read()
  end

  def list_tasks_related_to_opportunities() do
    from(t in Task,
      where:
        fragment("""
        (related_resource->>'type' = 'opportunity')
        """)
    )
    |> Task.read()
  end

  def list_tasks_related_to_opportunity(copper_id) do
    from(t in Task,
      where:
        fragment(
          """
          (related_resource->>'type' = 'opportunity') and
          (related_resource->>'id' = ?)
          """,
          ^to_string(copper_id)
        )
    )
    |> Task.read()
  end

  def test_tasks_related_to_opportunity(copper_id) do
    Ecto.Adapters.SQL.to_sql(
      :all,
      Repo,
      from(t in Task,
        where:
          fragment(
            """
            (related_resource->>'type' = 'opportunity') and
            (related_resource->>'id' = ?)
            """,
            ^to_string(copper_id)
          )
      )
    )
  end

  def list_tasks_related_to_leads() do
    from(t in Task,
      where:
        fragment("""
        (related_resource->>'type' = 'lead')
        """)
    )
    |> Task.read()
  end

  def list_tasks_related_to_lead(copper_id) do
    from(t in Task,
      where:
        fragment(
          """
          (related_resource->>'type' = 'lead') and
          (related_resource->>'id' = ?)
          """,
          ^to_string(copper_id)
        )
    )
    |> Task.read()
  end

  def count do
    from(t in Task, select: count(t.id))
    |> Task.read()
  end
end
