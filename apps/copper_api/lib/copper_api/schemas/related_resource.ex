defmodule CopperApi.Schemas.RelatedResource do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          id: integer(),
          type: String.t()
        }
  defstruct [
    :id,
    :type
  ]

  @spec new(%{
          id: integer(),
          type: String.t()
        }) :: CopperApi.Schemas.RelatedResource.t()
  def new(%{"id" => id, "type" => type}) do
    %__MODULE__{
      id: id,
      type: type
    }
  end
end
