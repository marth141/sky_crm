defmodule HubspotApi.Owner do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    archived
    createdAt
    email
    firstName
    hubspot_owner_id
    lastName
    teams
    updatedAt
    userId
  )a

  schema "hubspot_owners" do
    field(:archived, :boolean)
    field(:createdAt, :string)
    field(:email, :string)
    field(:firstName, :string)
    field(:hubspot_owner_id, :integer)
    field(:lastName, :string)
    field(:teams, {:array, :map})
    field(:updatedAt, :string)
    field(:userId, :integer)
  end

  def new(arg) do
    %__MODULE__{
      archived: arg["archived"],
      createdAt: arg["createdAt"],
      email: arg["email"],
      firstName: arg["firstName"],
      hubspot_owner_id: arg["id"],
      lastName: arg["lastName"],
      teams: arg["teams"],
      updatedAt: arg["updatedAt"],
      userId: arg["userId"]
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs |> Map.from_struct())
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :hubspot_owner_id)
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
