defmodule SightenApi.ReceivedSightenWebhook do
  @doc """
  Describes the properties that might come in from a webhook'd message from sighten
  """

  @default %{
    "previous_stage_id" => "some_value",
    "previous_stage_name" => "some_value",
    "site_id" => "some_value",
    "site_owned_by_organization" => "some_value",
    "stage_id" => "some_value",
    "stage_name" => "some_value"
  }

  defstruct ~w(
    previous_stage_id
    previous_stage_name
    site_id
    site_owned_by_organization
    stage_id
    stage_name
  )a

  def new!(%{
        "previous_stage_id" => previous_stage_id,
        "previous_stage_name" => previous_stage_name,
        "site_id" => site_id,
        "site_owned_by_organization" => site_owned_by_organization,
        "stage_id" => stage_id,
        "stage_name" => stage_name
      }) do
    %__MODULE__{
      previous_stage_id: previous_stage_id,
      previous_stage_name: previous_stage_name,
      site_id: site_id,
      site_owned_by_organization: site_owned_by_organization,
      stage_id: stage_id,
      stage_name: stage_name
    }
  end

  def new(%{
        "previous_stage_id" => previous_stage_id,
        "previous_stage_name" => previous_stage_name,
        "site_id" => site_id,
        "site_owned_by_organization" => site_owned_by_organization,
        "stage_id" => stage_id,
        "stage_name" => stage_name
      }) do
    {:ok,
     %__MODULE__{
       previous_stage_id: previous_stage_id,
       previous_stage_name: previous_stage_name,
       site_id: site_id,
       site_owned_by_organization: site_owned_by_organization,
       stage_id: stage_id,
       stage_name: stage_name
     }}
  end

  def new(nil) do
    {:error, "No object given"}
  end

  def new(%{}) do
    {:ok, new(@default)}
  end
end
