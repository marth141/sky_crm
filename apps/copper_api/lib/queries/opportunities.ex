defmodule CopperApi.Queries.Opportunities do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module was for querying copper opportunities.
  """
  alias CopperApi.Schemas.Opportunity
  alias CopperApi.Queries.Get
  import Ecto.Query

  def by_pipeline(pipeline_name) do
    from(o in Opportunity,
      where: o.pipeline_id == ^Get.pipeline_id_by_name(pipeline_name)
    )
    |> Opportunity.read()
  end

  def by_pipelines(pipeline_id_list) do
    from(o in Opportunity,
      where: o.pipeline_id == ^pipeline_id_list
    )
    |> Opportunity.read()
  end

  def by_copper_id(copper_id) do
    from(o in Opportunity, where: o.copper_id == ^copper_id, limit: 1)
    |> Opportunity.read()
  end

  def count do
    from(t in Opportunity, select: count(t.id))
    |> Opportunity.read()
  end
end
