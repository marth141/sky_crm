defmodule NetsuiteApi.UtilityCompany do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    created
    custrecord_bb_utility_company_state
    netsuite_utility_company_id
    isinactive
    lastmodified
    links
    name
    owner
    recordid
    scriptid
  )a

  schema "netsuite_utility_companies" do
    field(:created, :string)
    field(:custrecord_bb_utility_company_state, :string)
    field(:netsuite_utility_company_id, :string)
    field(:isinactive, :string)
    field(:lastmodified, :string)
    field(:links, {:array, :string})
    field(:name, :string)
    field(:owner, :string)
    field(:recordid, :string)
    field(:scriptid, :string)
  end

  def changeset(module, attrs \\ %{}) do
    module
    |> cast(attrs, @fields)
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_utility_company_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_utility_company_id)
  end

  def create_embedded(attrs) do
    with %Ecto.Changeset{valid?: true} = cs <-
           %__MODULE__{} |> changeset(attrs) do
      {:ok,
       cs.changes
       |> new()}
    end
  end

  def create_embedded!(attrs) do
    with %Ecto.Changeset{valid?: true} = cs <-
           %__MODULE__{} |> changeset(attrs) do
      cs.changes
      |> new()
    end
  end

  def update(original, attrs) do
    original
    |> changeset(attrs)
    |> Repo.update()
  end

  defp new(changeset_changes) do
    %__MODULE__{
      created: changeset_changes[:created],
      custrecord_bb_utility_company_state:
        changeset_changes[:custrecord_bb_utility_company_state],
      netsuite_utility_company_id: changeset_changes[:netsuite_utility_company_id],
      isinactive: changeset_changes[:isinactive],
      lastmodified: changeset_changes[:lastmodified],
      links: changeset_changes[:links],
      name: changeset_changes[:name],
      owner: changeset_changes[:owner],
      recordid: changeset_changes[:recordid],
      scriptid: changeset_changes[:scriptid]
    }
  end
end
