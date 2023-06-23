defmodule AhjRegistryApi do
  @moduledoc """
  Documentation for `AhjRegistryApi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AhjRegistryApi.hello()
      :world

  """
  def hello do
    :world
  end

  def search_by_address(opts \\ []) do
    addr_line_1 = Keyword.get(opts, :addr_line_1, "")
    addr_line_2 = Keyword.get(opts, :addr_line_2, "")
    addr_line_3 = Keyword.get(opts, :addr_line_3, "")
    city = Keyword.get(opts, :city, "")
    county = Keyword.get(opts, :county, "")
    state_province = Keyword.get(opts, :state_province, "")
    zip_postal_code = Keyword.get(opts, :zip_postal_code, "")

    Finch.build(
      :post,
      "https://ahjregistry.sunspec.org/api/v1/ahj/",
      [
        {"content-type", "application/json"},
        {"Authorization", Application.get_env(:ahj_registry_api, :api_token)}
      ],
      %{
        "Address" => %{
          "AddrLine1" => %{
            "Value" => addr_line_1
          },
          "AddrLine2" => %{
            "Value" => addr_line_2
          },
          "AddrLine3" => %{
            "Value" => addr_line_3
          },
          "City" => %{
            "Value" => city
          },
          "County" => %{
            "Value" => county
          },
          "StateProvince" => %{
            "Value" => state_province
          },
          "ZipPostalCode" => %{
            "Value" => zip_postal_code
          }
        }
      }
      |> Jason.encode!()
    )
    |> Finch.request(AhjRegistryApiFinch)
  end

  def search_by_location(
        latitude,
        longitude
      ) do
    Finch.build(
      :post,
      "https://ahjregistry.sunspec.org/api/v1/ahj/",
      [
        {"content-type", "application/json"},
        {"Authorization", Application.get_env(:ahj_registry_api, :api_token)}
      ],
      %{
        "Location" => %{
          "Latitude" => %{
            "Value" => latitude
          },
          "Longitude" => %{
            "Value" => longitude
          }
        }
      }
      |> Jason.encode!()
    )
    |> Finch.request(AhjRegistryApiFinch)
  end

  def search(body) do
    Finch.build(
      :post,
      "https://ahjregistry.sunspec.org/api/v1/ahj/",
      [
        {"content-type", "application/json"},
        {"Authorization", Application.get_env(:ahj_registry_api, :api_token)}
      ],
      body
      |> Jason.encode!()
    )
    |> Finch.request(AhjRegistryApiFinch)
  end
end
