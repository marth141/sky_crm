defmodule CopperApi.Schemas.Stages do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          win_probability: integer()
        }
  defstruct [
    :id,
    :name,
    :win_probability
  ]

  @spec new(%{
          id: integer(),
          name: String.t(),
          win_probability: float()
        }) :: CopperApi.Schemas.Stages.t()
  def new(%{
        "id" => id,
        "name" => name,
        "win_probability" => win_probability
      }) do
    %__MODULE__{
      id: id,
      name: name,
      win_probability: win_probability
    }
  end
end
