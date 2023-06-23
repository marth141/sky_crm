defmodule CopperApi.Schemas.CustomFieldDefinitionOption do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          rank: integer()
        }
  defstruct [
    :id,
    :name,
    :rank
  ]

  @spec new(%{
          id: integer(),
          name: String.t(),
          rank: integer()
        }) :: CopperApi.Schemas.CustomFieldDefinitionOption.t()
  def new(%{
        "id" => id,
        "name" => name,
        "rank" => rank
      }) do
    %__MODULE__{
      id: id,
      name: name,
      rank: rank
    }
  end
end
