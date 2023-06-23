defmodule CopperApi.Schemas.CreatePersonRequest do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  defstruct ~w(
    name
    emails
    address
    phone_numbers
  )a

  def new(%{
        "name" => name,
        "emails" => [%{"email" => _email, "category" => "personal"}] = emails,
        "address" =>
          %{
            "street" => _street,
            "city" => _city,
            "state" => _state,
            "postal_code" => _postal_code,
            "country" => _country
          } = address,
        "phone_numbers" => [%{"number" => _number, "category" => "mobile"}] = phone_numbers
      }) do
    %__MODULE__{
      name: name,
      emails: emails,
      address: address,
      phone_numbers: phone_numbers
    }
  end
end
