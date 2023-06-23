defmodule SightenApi.Schemas.Site.Contact do
  defstruct ~w(
    email
    first_name
    last_name
    phone_number
    primary
    site
    uuid
  )a

  def new(arg) do
    %__MODULE__{
      email: arg["email"],
      first_name: arg["first_name"],
      last_name: arg["last_name"],
      phone_number: arg["phone_number"],
      primary: arg["primary"],
      site: arg["site"],
      uuid: arg["uuid"]
    }
  end
end
