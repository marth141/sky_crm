defmodule HubspotApi.EngagementRecord do
  defstruct ~w(
    associations
    attachments
    engagement
    metadata
  )a

  def new(%{
        "associations" => associations,
        "attachments" => attachments,
        "engagement" => engagement,
        "metadata" => metadata
      }) do
    %__MODULE__{
      associations: associations,
      attachments: attachments,
      engagement: engagement,
      metadata: metadata
    }
  end
end
