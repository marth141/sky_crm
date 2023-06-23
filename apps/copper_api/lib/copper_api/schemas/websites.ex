defmodule CopperApi.Schemas.Websites do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          url: String.t(),
          category: String.t()
        }
  defstruct [
    :url,
    :category
  ]

  @spec new(%{
          :url => String.t(),
          :category => String.t()
        }) :: CopperApi.Schemas.Websites.t()
  def new(%{
        "url" => url,
        "category" => category
      }) do
    %__MODULE__{
      url: url,
      category: category
    }
  end
end
