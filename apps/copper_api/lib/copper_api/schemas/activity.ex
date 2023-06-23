defmodule CopperApi.Schemas.Activity do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    copper_id
    parent
    type
    user_id
    details
    activity_date
    date_created
    date_modified
  )a

  schema "copper_activities" do
    field(:copper_id, :integer)
    field(:parent, :map)
    field(:type, :map)
    field(:user_id, :integer)
    field(:details, :string)
    field(:activity_date, :integer)
    field(:date_created, :integer)
    field(:date_modified, :integer)
    field(:related_lead_id, :integer)
    field(:related_person_id, :integer)
    field(:related_company_id, :integer)
    field(:related_opportunity_id, :integer)
    field(:related_project_id, :integer)
    field(:related_task_id, :integer)

    belongs_to(
      :opportunity,
      CopperApi.Schemas.Opportunity,
      define_field: false,
      foreign_key: :related_opportunity_id
    )

    timestamps()
  end

  def new(%{
        "id" => id,
        "parent" => parent,
        "type" => type,
        "user_id" => user_id,
        "details" => details,
        "activity_date" => activity_date,
        "date_created" => date_created,
        "date_modified" => date_modified
      }) do
    %{
      copper_id: id,
      parent: parent,
      type: type,
      user_id: user_id,
      details: details,
      activity_date: activity_date,
      date_created: date_created,
      date_modified: date_modified,
      related_lead_id:
        if(parent |> Map.get("type") == "lead",
          do: parent |> Map.get("id"),
          else: nil
        ),
      related_person_id:
        if(parent |> Map.get("type") == "person",
          do: parent |> Map.get("id"),
          else: nil
        ),
      related_company_id:
        if(parent |> Map.get("type") == "company",
          do: parent |> Map.get("id"),
          else: nil
        ),
      related_opportunity_id:
        if(parent |> Map.get("type") == "opportunity",
          do: parent |> Map.get("id"),
          else: nil
        ),
      related_project_id:
        if(parent |> Map.get("type") == "project",
          do: parent |> Map.get("id"),
          else: nil
        ),
      related_task_id:
        if(parent |> Map.get("type") == "task",
          do: parent |> Map.get("id"),
          else: nil
        ),
      inserted_at: timestamp(),
      updated_at: timestamp()
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:copper_id])
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing, conflict_target: :copper_id)
  end

  def read() do
    Repo.all(__MODULE__)
  end

  def read(query) do
    Repo.all(query)
  end

  def update(original, attrs) do
    original
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete(original) do
    original
    |> Repo.delete!()
  end

  defp timestamp() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end
end
