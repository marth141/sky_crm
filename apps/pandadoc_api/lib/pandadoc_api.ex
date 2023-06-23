defmodule PandadocApi do
  defp pandadoc_token, do: Application.get_env(:pandadoc_api, :api_token)

  @moduledoc """
  Documentation for `PandadocApi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PandadocApi.hello()
      :world

  """
  def hello do
    :world
  end

  def send_document(document_id, params) do
    Finch.build(
      :post,
      "https://api.pandadoc.com/public/v1/documents/#{document_id}/send",
      [{"Authorization", "API-Key #{pandadoc_token()}"}, {"Content-Type", "application/json"}],
      params
      |> Jason.encode!()
    )
    |> Finch.request(PandadocApiFinch)
  end

  def list_templates() do
    Finch.build(
      :get,
      "https://api.pandadoc.com/public/v1/templates",
      [{"Authorization", "API-Key #{pandadoc_token()}"}]
    )
    |> Finch.request(PandadocApiFinch)
  end

  def get_template_details(template_id) do
    Finch.build(
      :get,
      "https://api.pandadoc.com/public/v1/templates/#{template_id}/details",
      [{"Authorization", "API-Key #{pandadoc_token()}"}]
    )
    |> Finch.request(PandadocApiFinch)
  end

  def create_document_from_template(arg) do
    arg =
      Map.update!(arg, "fields", fn fields ->
        Enum.map(fields, fn
          {k, %{"value" => v}} when is_nil(v) -> {k, %{"value" => ""}}
          {k, %{"value" => v}} -> {k, %{"value" => v}}
        end)
        |> Map.new()
      end)

    Finch.build(
      :post,
      "https://api.pandadoc.com/public/v1/documents",
      [
        {"Authorization", "API-Key #{pandadoc_token()}"},
        {"Content-Type", "application/json"}
      ],
      # Jason.encode!(%{
      #   "name" => "test document",
      #   "template_uuid" => "p52rLAroEru6iFToFMRHAj",
      #   "folder_uuid" => "58bLcsRwZxzsxYYfeyrxfX",
      #   "recipients" => [%{"email" => "support@org"}],
      #   "fields" => %{
      #     "netsuite.utility_account_name" => %{
      #       "value" => "Test value"
      #     }
      #   }
      # })

      Jason.encode!(arg)
    )
    |> Finch.request(PandadocApiFinch)
  end
end
