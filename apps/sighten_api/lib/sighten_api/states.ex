defmodule SightenApi.States do
  @moduledoc """
  When creating a sighten site, this is used to fix states that may come in with all kind of spellings

  As long as it is spelled correctly, it'll be translated to be sighten appropraite too

  Sighten only accepts 2 letter abbreviations for states so that's all this accepts and returns too
  """
  @spec state_to_abbreviation(String.t()) :: String.t() | nil
  def state_to_abbreviation(state) do
    state = String.trim(state)

    case String.length(state) > 2 do
      true ->
        get()
        |> Enum.find(fn %{"name" => name, "abbreviation" => _abbr} ->
          String.match?(name, ~r/#{state}/i)
        end)
        |> (fn map -> unless is_nil(map), do: map |> Map.get("abbreviation"), else: nil end).()

      false ->
        get()
        |> Enum.find(fn %{"name" => _name, "abbreviation" => abbr} ->
          String.match?(abbr, ~r/#{state}/i)
        end)
        |> (fn map -> unless is_nil(map), do: map |> Map.get("abbreviation"), else: nil end).()
    end
  end

  def get() do
    [
      %{
        "name" => "Alabama",
        "abbreviation" => "AL"
      },
      %{
        "name" => "Alaska",
        "abbreviation" => "AK"
      },
      %{
        "name" => "American Samoa",
        "abbreviation" => "AS"
      },
      %{
        "name" => "Arizona",
        "abbreviation" => "AZ"
      },
      %{
        "name" => "Arkansas",
        "abbreviation" => "AR"
      },
      %{
        "name" => "California",
        "abbreviation" => "CA"
      },
      %{
        "name" => "Colorado",
        "abbreviation" => "CO"
      },
      %{
        "name" => "Connecticut",
        "abbreviation" => "CT"
      },
      %{
        "name" => "Delaware",
        "abbreviation" => "DE"
      },
      %{
        "name" => "District Of Columbia",
        "abbreviation" => "DC"
      },
      %{
        "name" => "Federated States Of Micronesia",
        "abbreviation" => "FM"
      },
      %{
        "name" => "Florida",
        "abbreviation" => "FL"
      },
      %{
        "name" => "Georgia",
        "abbreviation" => "GA"
      },
      %{
        "name" => "Guam",
        "abbreviation" => "GU"
      },
      %{
        "name" => "Hawaii",
        "abbreviation" => "HI"
      },
      %{
        "name" => "Idaho",
        "abbreviation" => "ID"
      },
      %{
        "name" => "Illinois",
        "abbreviation" => "IL"
      },
      %{
        "name" => "Indiana",
        "abbreviation" => "IN"
      },
      %{
        "name" => "Iowa",
        "abbreviation" => "IA"
      },
      %{
        "name" => "Kansas",
        "abbreviation" => "KS"
      },
      %{
        "name" => "Kentucky",
        "abbreviation" => "KY"
      },
      %{
        "name" => "Louisiana",
        "abbreviation" => "LA"
      },
      %{
        "name" => "Maine",
        "abbreviation" => "ME"
      },
      %{
        "name" => "Marshall Islands",
        "abbreviation" => "MH"
      },
      %{
        "name" => "Maryland",
        "abbreviation" => "MD"
      },
      %{
        "name" => "Massachusetts",
        "abbreviation" => "MA"
      },
      %{
        "name" => "Michigan",
        "abbreviation" => "MI"
      },
      %{
        "name" => "Minnesota",
        "abbreviation" => "MN"
      },
      %{
        "name" => "Mississippi",
        "abbreviation" => "MS"
      },
      %{
        "name" => "Missouri",
        "abbreviation" => "MO"
      },
      %{
        "name" => "Montana",
        "abbreviation" => "MT"
      },
      %{
        "name" => "Nebraska",
        "abbreviation" => "NE"
      },
      %{
        "name" => "Nevada",
        "abbreviation" => "NV"
      },
      %{
        "name" => "New Hampshire",
        "abbreviation" => "NH"
      },
      %{
        "name" => "New Jersey",
        "abbreviation" => "NJ"
      },
      %{
        "name" => "New Mexico",
        "abbreviation" => "NM"
      },
      %{
        "name" => "New York",
        "abbreviation" => "NY"
      },
      %{
        "name" => "North Carolina",
        "abbreviation" => "NC"
      },
      %{
        "name" => "North Dakota",
        "abbreviation" => "ND"
      },
      %{
        "name" => "Northern Mariana Islands",
        "abbreviation" => "MP"
      },
      %{
        "name" => "Ohio",
        "abbreviation" => "OH"
      },
      %{
        "name" => "Oklahoma",
        "abbreviation" => "OK"
      },
      %{
        "name" => "Oregon",
        "abbreviation" => "OR"
      },
      %{
        "name" => "Palau",
        "abbreviation" => "PW"
      },
      %{
        "name" => "Pennsylvania",
        "abbreviation" => "PA"
      },
      %{
        "name" => "Puerto Rico",
        "abbreviation" => "PR"
      },
      %{
        "name" => "Rhode Island",
        "abbreviation" => "RI"
      },
      %{
        "name" => "South Carolina",
        "abbreviation" => "SC"
      },
      %{
        "name" => "South Dakota",
        "abbreviation" => "SD"
      },
      %{
        "name" => "Tennessee",
        "abbreviation" => "TN"
      },
      %{
        "name" => "Texas",
        "abbreviation" => "TX"
      },
      %{
        "name" => "Utah",
        "abbreviation" => "UT"
      },
      %{
        "name" => "Vermont",
        "abbreviation" => "VT"
      },
      %{
        "name" => "Virgin Islands",
        "abbreviation" => "VI"
      },
      %{
        "name" => "Virginia",
        "abbreviation" => "VA"
      },
      %{
        "name" => "Washington",
        "abbreviation" => "WA"
      },
      %{
        "name" => "West Virginia",
        "abbreviation" => "WV"
      },
      %{
        "name" => "Wisconsin",
        "abbreviation" => "WI"
      },
      %{
        "name" => "Wyoming",
        "abbreviation" => "WY"
      }
    ]
  end
end
