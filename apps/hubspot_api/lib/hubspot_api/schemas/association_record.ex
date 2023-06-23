defmodule HubspotApi.AssociationRecord do
  defstruct ~w(
    id
    type
  )a

  def new(%{"id" => id, "type" => type}) do
    %__MODULE__{
      id: id,
      type: type
    }
  end
end
