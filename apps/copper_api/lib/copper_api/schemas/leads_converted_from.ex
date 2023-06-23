defmodule CopperApi.Schemas.LeadsConvertedFrom do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          lead_id: integer(),
          converted_timestamp: integer()
        }
  defstruct [
    :lead_id,
    :converted_timestamp
  ]

  @spec new(%{
          lead_id: integer(),
          converted_timestamp: integer()
        }) :: CopperApi.Schemas.LeadsConvertedFrom.t()
  def new(%{"lead_id" => lead_id, "converted_timestamp" => converted_timestamp}) do
    %__MODULE__{lead_id: lead_id, converted_timestamp: converted_timestamp}
  end
end
