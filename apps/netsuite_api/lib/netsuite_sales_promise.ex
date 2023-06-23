defmodule NetsuiteApi.SalesPromise do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    netsuite_sales_promise_id
    isInactive
    name
    scriptId
  )a

  schema "netsuite_sales_promises" do
    field(:netsuite_sales_promise_id, :string)
    field(:isInactive, :boolean)
    field(:name, :string)
    field(:scriptId, :string)
  end

  def changeset(module, attrs \\ %{}) do
    module
    |> cast(attrs, @fields)
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_sales_promise_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_sales_promise_id)
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
      netsuite_sales_promise_id: changeset_changes[:netsuite_sales_promise_id],
      isInactive: changeset_changes[:isInactive],
      name: changeset_changes[:name],
      scriptId: changeset_changes[:scriptId]
    }
  end
end
