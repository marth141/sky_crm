defmodule NetsuiteApi.LeadSource do
  @doc """
  This is used to describe a Netsuite Employee with Ecto Schemas
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    netsuite_lead_source_id
    isinactive
    links
    name
    recordid
    scriptid
  )a

  schema "netsuite_lead_sources" do
    field(:netsuite_lead_source_id, :string)
    field(:isinactive, :string)
    field(:links, {:array, :string})
    field(:name, :string)
    field(:recordid, :string)
    field(:scriptid, :string)

    timestamps()
  end

  def new(%{}) do
    %__MODULE__{}
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:netsuite_employee_id])
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_lead_source_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_lead_source_id)
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
end
