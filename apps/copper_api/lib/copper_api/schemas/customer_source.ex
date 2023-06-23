defmodule CopperApi.Schemas.CustomerSource do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }
  defstruct [
    :id,
    :name
  ]

  @spec new(%{
          id: integer(),
          name: String.t()
        }) :: CopperApi.Schemas.CustomerSource.t()
  def new(%{
        "id" => id,
        "name" => name
      }) do
    %__MODULE__{
      id: id,
      name: name
    }
  end
end
