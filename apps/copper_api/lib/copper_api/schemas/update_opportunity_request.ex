defmodule CopperApi.Schemas.UpdateOpportunityRequest do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  defstruct ~w(
    copper_id
    custom_fields
  )a

  def new(%{
        "copper_id" => copper_id,
        "custom_fields" => custom_fields
      }) do
    %__MODULE__{
      copper_id: copper_id,
      custom_fields: custom_fields
    }
  end
end
