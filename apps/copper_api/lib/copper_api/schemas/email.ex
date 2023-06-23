defmodule CopperApi.Schemas.Email do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          email: String.t(),
          category: String.t()
        }
  defstruct [
    :email,
    :category
  ]

  @spec new(
          nil
          | %{
              email: String.t(),
              category: String.t()
            }
        ) :: CopperApi.Schemas.Email.t()
  def new(%{
        "email" => email,
        "category" => category
      }) do
    %__MODULE__{
      email: email,
      category: category
    }
  end

  def new(nil) do
    %__MODULE__{
      email: nil,
      category: nil
    }
  end
end
