defmodule CopperApi.Schemas.ActivityType do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """

  @type t :: %__MODULE__{
          category: String.t(),
          count_as_interaction: boolean(),
          id: integer(),
          is_disabled: boolean(),
          name: String.t()
        }
  defstruct [
    :category,
    :count_as_interaction,
    :id,
    :is_disabled,
    :name
  ]

  @spec new(%{
          category: String.t(),
          count_as_interaction: boolean(),
          id: integer(),
          is_disabled: boolean(),
          name: String.t()
        }) :: CopperApi.Schemas.ActivityType.t()
  def new(%{
        "category" => category,
        "count_as_interaction" => count_as_interaction,
        "id" => id,
        "is_disabled" => is_disabled,
        "name" => name
      }) do
    %__MODULE__{
      category: category,
      count_as_interaction: count_as_interaction,
      id: id,
      is_disabled: is_disabled,
      name: name
    }
  end
end
