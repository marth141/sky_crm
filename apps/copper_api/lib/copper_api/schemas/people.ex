defmodule CopperApi.Schemas.People do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    copper_id
    name
    prefix
    first_name
    last_name
    suffix
    address
    assignee_id
    company_id
    company_name
    contact_type_id
    details
    emails
    phone_numbers
    socials
    tags
    title
    websites
    custom_fields
    date_created
    date_modified
    date_last_contacted
    interaction_count
    leads_converted_from
    date_lead_created
  )a

  schema "copper_people" do
    field(:copper_id, :integer)
    field(:name, :string)
    field(:prefix, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:suffix, :string)
    field(:address, :map)
    field(:assignee_id, :integer)
    field(:company_id, :integer)
    field(:company_name, :string)
    field(:contact_type_id, :integer)
    field(:details, :string)
    field(:emails, {:array, :map})
    field(:phone_numbers, {:array, :map})
    field(:socials, {:array, :map})
    field(:tags, {:array, :string})
    field(:title, :string)
    field(:websites, {:array, :map})
    field(:custom_fields, {:array, :map})
    field(:date_created, :integer)
    field(:date_modified, :integer)
    field(:date_last_contacted, :integer)
    field(:interaction_count, :integer)
    field(:leads_converted_from, {:array, :map})
    field(:date_lead_created, :integer)

    timestamps()
  end

  def new(%{
        "id" => id,
        "name" => name,
        "prefix" => prefix,
        "first_name" => first_name,
        "last_name" => last_name,
        "suffix" => suffix,
        "address" => address,
        "assignee_id" => assignee_id,
        "company_id" => company_id,
        "company_name" => company_name,
        "contact_type_id" => contact_type_id,
        "details" => details,
        "emails" => emails,
        "phone_numbers" => phone_numbers,
        "socials" => socials,
        "tags" => tags,
        "title" => title,
        "websites" => websites,
        "custom_fields" => custom_fields,
        "date_created" => date_created,
        "date_modified" => date_modified,
        "date_last_contacted" => date_last_contacted,
        "interaction_count" => interaction_count,
        "leads_converted_from" => leads_converted_from,
        "date_lead_created" => date_lead_created
      }) do
    %__MODULE__{
      copper_id: id,
      name: name,
      prefix: prefix,
      first_name: first_name,
      last_name: last_name,
      suffix: suffix,
      address: address,
      assignee_id: assignee_id,
      company_id: company_id,
      company_name: company_name,
      contact_type_id: contact_type_id,
      details: details,
      emails: emails,
      phone_numbers: phone_numbers,
      socials: socials,
      tags: tags,
      title: title,
      websites: websites,
      custom_fields: custom_fields,
      date_created: date_created,
      date_modified: date_modified,
      date_last_contacted: date_last_contacted,
      interaction_count: interaction_count,
      leads_converted_from: leads_converted_from,
      date_lead_created: date_lead_created
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:copper_id])
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :copper_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(Map.from_struct(attrs))
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :copper_id)
  end

  def read() do
    Repo.all(__MODULE__)
  end

  def read(query) do
    Repo.all(query)
  end

  def update(original, attrs) do
    original
    |> changeset(Map.from_struct(attrs))
    |> Repo.update()
  end

  def delete(original) do
    original
    |> Repo.delete!()
  end
end
