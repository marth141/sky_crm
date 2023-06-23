defmodule CopperApi.Queries.Leads do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module was for doing stuff with Copper Leads
  """
  alias CopperApi.Schemas.Lead
  alias CopperApi.Queries.Get
  import Ecto.Query

  def list() do
    Lead.read()
  end

  def count_leads_created_today() do
    beginning_of_today_unix = TimeApi.today() |> TimeApi.beginning_of_day() |> TimeApi.to_unix()

    end_of_today_unix = TimeApi.today() |> TimeApi.end_of_day() |> TimeApi.to_unix()

    from(l in Lead,
      where: l.date_created >= ^beginning_of_today_unix and l.date_created <= ^end_of_today_unix,
      select: count(l.id)
    )
  end

  def leads_created_today() do
    beginning_of_today_unix = TimeApi.today() |> TimeApi.beginning_of_day() |> TimeApi.to_unix()

    end_of_today_unix = TimeApi.today() |> TimeApi.end_of_day() |> TimeApi.to_unix()

    from(l in Lead,
      where: l.date_created >= ^beginning_of_today_unix and l.date_created <= ^end_of_today_unix,
      order_by: l.name
    )
  end

  def by_copper_id(copper_id) do
    from(l in Lead, where: l.copper_id == ^copper_id)
  end

  def by_local_id(id) do
    from(l in Lead, where: l.id == ^id)
  end

  def by_unassigned() do
    custom_field = %{
      "custom_field_definition_id" =>
        Get.custom_field_definition_id_by_name("Setter/Specialist Name"),
      "value" => nil
    }

    from(l in Lead,
      where: is_nil(l.assignee_id) and ^custom_field in l.custom_fields
    )
  end

  def paginate(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(l in Lead,
      order_by: [asc: :date_created]
    )
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def paginate_unassigned(opts \\ []) do
    custom_field = %{
      "custom_field_definition_id" =>
        Get.custom_field_definition_id_by_name("Setter/Specialist Name"),
      "value" => nil
    }

    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 20)

    from(l in Lead,
      where: is_nil(l.assignee_id) and ^custom_field in l.custom_fields and l.status == "New",
      order_by: [asc: :date_created]
    )
    |> Repo.LonelyPaginator.paginate(Repo, page: page, per_page: per_page)
  end

  def count do
    alias CopperApi.Queries

    from(t in Lead, select: count(t.id))
    |> Queries.execute_query()
  end
end
