defmodule SightenApi.CreateSiteRequest do
  @moduledoc """
  Used to describe what proper parameters are needed to make a sighten site
  """
  defstruct ~w(
    street_address
    city
    state_region
    zip
    email
    first_name
    last_name
    phone_number
    external_id
    hs_object_id
  )a

  # embedded_schema do
  #   field(:street_address, :string)
  #   field(:city, :string)
  #   field(:state_region, :string)
  #   field(:zip, :string)
  #   field(:email, :string)
  #   field(:first_name, :string)
  #   field(:last_name, :string)
  #   field(:phone_number, :string)
  #   field(:external_id, :string)
  #   field(:hs_object_id, :string)
  # end

  def new(%{
        "city" => city,
        "email" => email,
        "first_name" => first_name,
        "last_name" => last_name,
        "phone_number" => phone_number,
        "state_region" => state_region,
        "street_address" => street_address,
        "zip" => zip,
        "hs_object_id" => external_id
      }) do
    {:ok,
     %__MODULE__{
       street_address: street_address,
       city: city,
       state_region:
         unless(state_region == nil,
           do:
             state_region
             |> String.trim()
             |> String.upcase()
             |> SightenApi.States.state_to_abbreviation(),
           else: state_region
         ),
       zip: zip,
       email: email,
       first_name: first_name,
       last_name: last_name,
       phone_number: phone_number,
       external_id: external_id
     }}
  end
end
