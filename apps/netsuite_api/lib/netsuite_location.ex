defmodule NetsuiteApi.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    netsuite_location_id
    custrecord_bb_preferred_location
    fullname
    isinactive
    lastmodifieddate
    links
    mainaddress
    makeinventoryavailable
    makeinventoryavailablestore
    name
    subsidiary
    usebins
  )a

  schema "netsuite_locations" do
    field(:netsuite_location_id, :string)
    field(:custrecord_bb_preferred_location, :string)
    field(:fullname, :string)
    field(:isinactive, :string)
    field(:lastmodifieddate, :string)
    field(:links, {:array, :string})
    field(:mainaddress, :string)
    field(:makeinventoryavailable, :string)
    field(:makeinventoryavailablestore, :string)
    field(:name, :string)
    field(:subsidiary, :string)
    field(:usebins, :string)
  end

  def changeset(module, attrs \\ %{}) do
    module
    |> cast(attrs, @fields)
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_location_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_location_id)
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
      netsuite_location_id: changeset_changes[:netsuite_location_id],
      custrecord_bb_preferred_location: changeset_changes[:custrecord_bb_preferred_location],
      fullname: changeset_changes[:fullname],
      isinactive: changeset_changes[:isinactive],
      lastmodifieddate: changeset_changes[:lastmodifieddate],
      links: changeset_changes[:links],
      mainaddress: changeset_changes[:mainaddress],
      makeinventoryavailable: changeset_changes[:makeinventoryavailable],
      makeinventoryavailablestore: changeset_changes[:makeinventoryavailablestore],
      name: changeset_changes[:name],
      subsidiary: changeset_changes[:subsidiary],
      usebins: changeset_changes[:usebins]
    }
  end
end
