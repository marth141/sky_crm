defmodule CopperApi.Schemas.Pipeline do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  alias CopperApi.Schemas.{
    Stages
  }

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          stages: [%Stages{}]
        }
  defstruct [
    :id,
    :name,
    :stages
  ]

  @spec new(%{
          id: integer(),
          name: String.t(),
          stages: [
            %{
              id: integer(),
              name: String.t(),
              win_probability: float()
            }
          ]
        }) :: CopperApi.Schemas.Pipeline.t()
  def new(%{"id" => id, "name" => name, "stages" => stages}) do
    %__MODULE__{
      id: id,
      name: name,
      stages: Enum.map(stages, &Stages.new/1)
    }
  end
end
