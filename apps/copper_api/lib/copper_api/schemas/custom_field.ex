defmodule CopperApi.Schemas.CustomField do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          custom_field_definition_id: integer(),
          value: any()
        }
  defstruct [
    :custom_field_definition_id,
    :value
  ]

  @spec new(%{
          custom_field_definition_id: integer(),
          value: any()
        }) :: CopperApi.Schemas.CustomField.t()
  def new(%{"custom_field_definition_id" => custom_field_definition_id, "value" => value}) do
    %__MODULE__{
      custom_field_definition_id: custom_field_definition_id,
      value: value
    }
  end
end
