defmodule CopperApi.Schemas.PhoneNumbers do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          number: String.t(),
          category: String.t()
        }
  defstruct [
    :number,
    :category
  ]

  @spec new(%{
          number: String.t(),
          category: String.t()
        }) :: CopperApi.Schemas.PhoneNumbers.t()
  def new(%{
        "number" => number,
        "category" => category
      }) do
    %__MODULE__{
      number: number,
      category: category
    }
  end
end
