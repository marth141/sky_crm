defmodule CopperApi.Schemas.CreateOpportunityRequest do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  defstruct ~w(
    name
    primary_contact_id
    custom_fields
    close_date
    monetary_value
    pipeline_id
    pipeline_stage_id
  )a

  def new(%{
        "name" => name,
        "primary_contact_id" => primary_contact_id,
        "custom_fields" => custom_fields,
        "close_date" => close_date,
        "monetary_value" => monetary_value,
        "pipeline_id" => pipeline_id,
        "pipeline_stage_id" => pipeline_stage_id
      }) do
    %__MODULE__{
      name: name,
      primary_contact_id: primary_contact_id,
      custom_fields: custom_fields,
      close_date: close_date,
      monetary_value: monetary_value,
      pipeline_id: pipeline_id,
      pipeline_stage_id: pipeline_stage_id
    }
  end
end
