defmodule CopperApi.Schemas.User do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          email: String.t(),
          id: integer(),
          name: String.t()
        }
  defstruct [
    :email,
    :id,
    :name
  ]

  @spec new(%{
          email: String.t(),
          id: integer(),
          name: String.t()
        }) :: CopperApi.Schemas.User.t()
  def new(%{
        "email" => email,
        "id" => id,
        "name" => name
      }) do
    %__MODULE__{
      email: email,
      id: id,
      name: name
    }
  end
end
