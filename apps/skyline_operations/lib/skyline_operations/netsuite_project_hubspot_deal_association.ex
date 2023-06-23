defmodule SkylineOperations.NetsuiteProjectHubspotDealAssociation do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    netsuite_parent_customer_id
    netsuite_sub_customer_id
    netsuite_project_id
    hubspot_contact_id
    hubspot_deal_id
    project_status
  )a

  schema "netsuite_project_hubspot_deal_association_table" do
    field(:netsuite_parent_customer_id, :integer)
    field(:netsuite_sub_customer_id, :integer)
    field(:netsuite_project_id, :integer)
    field(:hubspot_contact_id, :integer)
    field(:hubspot_deal_id, :integer)
    field(:project_status, :string)
    timestamps()
  end

  def new(%{
        "netsuite_parent_customer_id" => netsuite_parent_customer_id,
        "netsuite_sub_customer_id" => netsuite_sub_customer_id,
        "netsuite_project_id" => netsuite_project_id,
        "hubspot_contact_id" => hubspot_contact_id,
        "hubspot_deal_id" => hubspot_deal_id,
        "project_status" => project_status
      }) do
    %{
      netsuite_parent_customer_id: netsuite_parent_customer_id,
      netsuite_sub_customer_id: netsuite_sub_customer_id,
      netsuite_project_id: netsuite_project_id,
      hubspot_contact_id: hubspot_contact_id,
      hubspot_deal_id: hubspot_deal_id,
      project_status: project_status
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:hubspot_deal_id])
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(
      on_conflict: :replace_all,
      conflict_target: :hubspot_deal_id
    )
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
