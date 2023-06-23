defmodule CopperApi.Schemas.Address do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  @type t :: %__MODULE__{
          street: String.t(),
          city: String.t(),
          state: String.t(),
          postal_code: String.t(),
          country: String.t()
        }
  defstruct [
    :street,
    :city,
    :state,
    :postal_code,
    :country
  ]

  @spec new(
          nil
          | %{
              street: String.t(),
              city: String.t(),
              state: String.t(),
              postal_code: String.t(),
              country: String.t()
            }
        ) :: CopperApi.Schemas.Address.t()
  def new(%{
        "street" => street,
        "city" => city,
        "state" => state,
        "postal_code" => postal_code,
        "country" => country
      }) do
    %__MODULE__{
      street: street,
      city: city,
      state: state,
      postal_code: postal_code,
      country: country
    }
  end

  def new(nil) do
    %__MODULE__{
      street: nil,
      city: nil,
      state: nil,
      postal_code: nil,
      country: nil
    }
  end
end
