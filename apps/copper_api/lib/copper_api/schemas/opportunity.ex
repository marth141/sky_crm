defmodule CopperApi.Schemas.Opportunity do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    copper_id
    name
    assignee_id
    close_date
    company_id
    company_name
    customer_source_id
    details
    loss_reason_id
    pipeline_id
    pipeline_stage_id
    primary_contact_id
    priority
    status
    tags
    interaction_count
    monetary_unit
    monetary_value
    converted_unit
    converted_value
    win_probability
    date_stage_changed
    date_last_contacted
    leads_converted_from
    date_lead_created
    date_created
    date_modified
    custom_fields
    install_date
    install_area
    install_completed_date
    install_funded_date
  )a

  schema "copper_opportunities" do
    field(:copper_id, :integer)
    field(:name, :string)
    field(:assignee_id, :integer)
    field(:close_date, :integer)
    field(:company_id, :integer)
    field(:company_name, :string)
    field(:customer_source_id, :integer)
    field(:details, :string)
    field(:loss_reason_id, :integer)
    field(:pipeline_id, :integer)
    field(:pipeline_stage_id, :integer)
    field(:primary_contact_id, :integer)
    field(:priority, :string)
    field(:status, :string)
    field(:tags, {:array, :string})
    field(:interaction_count, :integer)
    field(:monetary_unit, :string)
    field(:monetary_value, :decimal)
    field(:converted_unit, :string)
    field(:converted_value, :string)
    field(:win_probability, :decimal)
    field(:date_stage_changed, :integer)
    field(:date_last_contacted, :integer)
    field(:leads_converted_from, {:array, :map})
    field(:date_lead_created, :integer)
    field(:date_created, :integer)
    field(:date_modified, :integer)
    field(:custom_fields, {:array, :map})
    field(:install_date, :integer)
    field(:install_area, :string)
    field(:install_completed_date, :integer)
    field(:install_funded_date, :integer)

    belongs_to(
      :primary_contact,
      CopperApi.Schemas.People,
      foreign_key: :primary_contact_id,
      define_field: false,
      references: :copper_id
    )

    has_many(
      :tasks,
      CopperApi.Schemas.Task,
      foreign_key: :related_opportunity_id,
      references: :copper_id
    )

    has_many(
      :activities,
      CopperApi.Schemas.Activity,
      foreign_key: :related_opportunity_id,
      references: :copper_id
    )

    timestamps()
  end

  def new(%{
        "id" => id,
        "name" => name,
        "assignee_id" => assignee_id,
        "close_date" => close_date,
        "company_id" => company_id,
        "company_name" => company_name,
        "customer_source_id" => customer_source_id,
        "details" => details,
        "loss_reason_id" => loss_reason_id,
        "pipeline_id" => pipeline_id,
        "pipeline_stage_id" => pipeline_stage_id,
        "primary_contact_id" => primary_contact_id,
        "priority" => priority,
        "status" => status,
        "tags" => tags,
        "interaction_count" => interaction_count,
        "monetary_unit" => monetary_unit,
        "monetary_value" => monetary_value,
        "converted_unit" => converted_unit,
        "converted_value" => converted_value,
        "win_probability" => win_probability,
        "date_stage_changed" => date_stage_changed,
        "date_last_contacted" => date_last_contacted,
        "leads_converted_from" => leads_converted_from,
        "date_lead_created" => date_lead_created,
        "date_created" => date_created,
        "date_modified" => date_modified,
        "custom_fields" => custom_fields
      }) do
    %__MODULE__{
      copper_id: id,
      name: name,
      assignee_id: assignee_id,
      close_date:
        if(is_nil(close_date),
          do: close_date,
          else: close_date |> TimeApi.parse_to_date() |> TimeApi.to_unix()
        ),
      company_id: company_id,
      company_name: company_name,
      customer_source_id: customer_source_id,
      details: details,
      loss_reason_id: loss_reason_id,
      pipeline_id: pipeline_id,
      pipeline_stage_id: pipeline_stage_id,
      primary_contact_id: primary_contact_id,
      priority: priority,
      status: status,
      tags: tags,
      interaction_count: interaction_count,
      monetary_unit: monetary_unit,
      monetary_value: monetary_value,
      converted_unit: converted_unit,
      converted_value: converted_value,
      win_probability: win_probability,
      date_stage_changed: date_stage_changed,
      date_last_contacted: date_last_contacted,
      leads_converted_from: leads_converted_from,
      date_lead_created: date_lead_created,
      date_created: date_created,
      date_modified: date_modified,
      custom_fields: custom_fields,
      install_date:
        custom_fields
        |> Enum.find(fn custom_field ->
          custom_field["custom_field_definition_id"] ==
            CopperApi.Queries.Get.custom_field_definition_id_by_name(
              "---------------------------INSTALL DATE---------------------------"
            )
        end)
        |> Map.get("value"),
      install_area:
        custom_fields
        |> Enum.find(fn custom_field -> custom_field["custom_field_definition_id"] == 262_731 end)
        |> (fn custom_field ->
              unless is_nil(custom_field["value"]) do
                custom_field["value"]
                |> CopperApi.Queries.Get.custom_field_dropdown_value_name_by_id(262_731)
              else
                custom_field["value"]
              end
            end).(),
      install_completed_date:
        custom_fields
        |> Enum.find(fn custom_field ->
          custom_field["custom_field_definition_id"] ==
            CopperApi.Queries.Get.custom_field_definition_id_by_name("**Install Completed")
        end)
        |> Map.get("value"),
      install_funded_date:
        custom_fields
        |> Enum.find(fn custom_field ->
          custom_field["custom_field_definition_id"] ==
            CopperApi.Queries.Get.custom_field_definition_id_by_name("**Install Funded Date")
        end)
        |> Map.get("value"),
      inserted_at: timestamp(),
      updated_at: timestamp()
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
    |> changeset(attrs)
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
