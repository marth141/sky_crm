defmodule CopperApi.Schemas.Lead do
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
    middle_name
    suffix
    address
    assignee_id
    company_name
    customer_source_id
    details
    email
    interaction_count
    monetary_unit
    monetary_value
    converted_unit
    converted_value
    socials
    status
    status_id
    tags
    title
    websites
    phone_numbers
    custom_fields
    date_created
    date_modified
    date_last_contacted
    converted_opportunity_id
    converted_contact_id
    converted_at
  )a

  schema "copper_leads" do
    field(:copper_id, :integer)
    field(:name, :string)
    field(:prefix, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:middle_name, :string)
    field(:suffix, :string)
    field(:address, :map)
    field(:assignee_id, :integer)
    field(:company_name, :string)
    field(:customer_source_id, :integer)
    field(:details, :string)
    field(:email, :map)
    field(:interaction_count, :integer)
    field(:monetary_unit, :string)
    field(:monetary_value, :string)
    field(:converted_unit, :string)
    field(:converted_value, :string)
    field(:socials, {:array, :map})
    field(:status, :string)
    field(:status_id, :integer)
    field(:tags, {:array, :string})
    field(:title, :string)
    field(:websites, {:array, :map})
    field(:phone_numbers, {:array, :map})
    field(:custom_fields, {:array, :map})
    field(:date_created, :integer)
    field(:date_modified, :integer)
    field(:date_last_contacted, :integer)
    field(:converted_opportunity_id, :integer)
    field(:converted_contact_id, :integer)
    field(:converted_at, :integer)

    timestamps()
  end

  def new(%{
        "id" => id,
        "name" => name,
        "prefix" => prefix,
        "first_name" => first_name,
        "last_name" => last_name,
        "middle_name" => middle_name,
        "suffix" => suffix,
        "address" => address,
        "assignee_id" => assignee_id,
        "company_name" => company_name,
        "customer_source_id" => customer_source_id,
        "details" => details,
        "email" => email,
        "interaction_count" => interaction_count,
        "monetary_unit" => monetary_unit,
        "monetary_value" => monetary_value,
        "converted_unit" => converted_unit,
        "converted_value" => converted_value,
        "socials" => socials,
        "status" => status,
        "status_id" => status_id,
        "tags" => tags,
        "title" => title,
        "websites" => websites,
        "phone_numbers" => phone_numbers,
        "custom_fields" => custom_fields,
        "date_created" => date_created,
        "date_modified" => date_modified,
        "date_last_contacted" => date_last_contacted,
        "converted_opportunity_id" => converted_opportunity_id,
        "converted_contact_id" => converted_contact_id,
        "converted_at" => converted_at
      }) do
    %{
      copper_id: id,
      name: name,
      prefix: prefix,
      first_name: first_name,
      last_name: last_name,
      middle_name: middle_name,
      suffix: suffix,
      address: address,
      assignee_id: assignee_id,
      company_name: company_name,
      customer_source_id: customer_source_id,
      details: details,
      email: email,
      interaction_count: interaction_count,
      monetary_unit: monetary_unit,
      monetary_value: monetary_value,
      converted_unit: converted_unit,
      converted_value: converted_value,
      socials: socials,
      status: status,
      status_id: status_id,
      tags: tags,
      title: title,
      websites: websites,
      phone_numbers: phone_numbers,
      custom_fields: custom_fields,
      date_created: date_created,
      date_modified: date_modified,
      date_last_contacted: date_last_contacted,
      converted_opportunity_id: converted_opportunity_id,
      converted_contact_id: converted_contact_id,
      converted_at: converted_at,
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
