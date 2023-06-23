defmodule CopperApi.Schemas.Task do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    copper_id
    name
    related_resource
    related_opportunity_id
    assignee_id
    due_date
    reminder_date
    completed_date
    priority
    status
    details
    tags
    custom_fields
    date_created
    date_modified
    custom_activity_type_id
  )a

  schema "copper_tasks" do
    field(:copper_id, :integer)
    field(:name, :string)
    field(:related_resource, :map)
    field(:related_opportunity_id, :integer)
    field(:assignee_id, :integer)
    field(:due_date, :integer)
    field(:reminder_date, :integer)
    field(:completed_date, :integer)
    field(:priority, :string)
    field(:status, :string)
    field(:details, :string)
    field(:tags, {:array, :string})
    field(:custom_fields, {:array, :map})
    field(:date_created, :integer)
    field(:date_modified, :integer)
    field(:custom_activity_type_id, :integer)

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
        "name" => name,
        "related_resource" => related_resource,
        "assignee_id" => assignee_id,
        "due_date" => due_date,
        "reminder_date" => reminder_date,
        "completed_date" => completed_date,
        "priority" => priority,
        "status" => status,
        "details" => details,
        "tags" => tags,
        "custom_fields" => custom_fields,
        "date_created" => date_created,
        "date_modified" => date_modified,
        "custom_activity_type_id" => custom_activity_type_id
      }) do
    %{
      copper_id: id,
      name: name,
      related_resource: related_resource,
      related_opportunity_id:
        if(related_resource |> Map.get("type") == "opportunity",
          do: related_resource |> Map.get("id"),
          else: nil
        ),
      assignee_id: assignee_id,
      due_date: due_date,
      reminder_date: reminder_date,
      completed_date: completed_date,
      priority: priority,
      status: status,
      details: details,
      tags: tags,
      custom_fields: custom_fields,
      date_created: date_created,
      date_modified: date_modified,
      custom_activity_type_id: custom_activity_type_id,
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

  def timestamp() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end
end
