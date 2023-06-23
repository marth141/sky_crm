defmodule CopperApi.Schemas.WebhookBody do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  defstruct ~w(
    event
    ids
    key
    secret
    subscription_id
    type
    updated_attributes
  )a

  def new(%{
        "event" => event,
        "ids" => ids,
        "key" => key,
        "secret" => secret,
        "subscription_id" => subscription_id,
        "type" => type,
        "updated_attributes" => updated_attributes
      }) do
    {:ok,
     %__MODULE__{
       event: event,
       ids: ids,
       key: key,
       secret: secret,
       subscription_id: subscription_id,
       type: type,
       updated_attributes: updated_attributes
     }}
  end
end
