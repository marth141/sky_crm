defmodule HubspotApi.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    archived
    createdAt
    hubspot_contact_id
    properties
    updatedAt
  )a

  schema "hubspot_contacts" do
    field(:archived, :boolean)
    field(:createdAt, :string)
    field(:hubspot_contact_id, :integer)
    field(:properties, :map)
    field(:updatedAt, :string)
  end

  def new(arg) do
    %__MODULE__{
      archived: arg["archived"],
      createdAt: arg["createdAt"],
      hubspot_contact_id: arg["id"],
      properties: arg["properties"],
      updatedAt: arg["updatedAt"]
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs |> Map.from_struct())
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :hubspot_contact_id)
  end

  def read() do
    Repo.all(__MODULE__)
  end

  def read(query) do
    Repo.all(query)
  end

  def update(original, attrs) do
    original
    |> changeset(attrs |> Map.from_struct())
    |> Repo.update()
  end

  def delete(original) do
    original
    |> Repo.delete!()
  end
end
