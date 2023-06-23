defmodule HubspotApi.Deal do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    archived
    createdAt
    hubspot_deal_id
    hubspot_owner_id
    properties
    updatedAt
  )a

  schema "hubspot_deals" do
    field(:archived, :boolean)
    field(:createdAt, :string)
    field(:hubspot_deal_id, :integer)
    field(:hubspot_owner_id, :integer)
    field(:properties, :map)
    field(:updatedAt, :string)
  end

  def new(%{"objectId" => _id} = arg) do
    %__MODULE__{
      archived: arg["archived"],
      createdAt: arg["createdAt"],
      hubspot_deal_id: arg["objectId"],
      hubspot_owner_id: arg["properties"]["hubspot_owner_id"],
      properties: arg["properties"],
      updatedAt: arg["updatedAt"]
    }
  end

  def new(%{"id" => _id} = arg) do
    %__MODULE__{
      archived: arg["archived"],
      createdAt: arg["createdAt"],
      hubspot_deal_id: arg["id"],
      hubspot_owner_id: arg["properties"]["hubspot_owner_id"],
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
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :hubspot_deal_id)
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
