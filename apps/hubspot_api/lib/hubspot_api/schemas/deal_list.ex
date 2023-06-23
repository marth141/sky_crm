defmodule HubspotApi.DealList do
  use Ecto.Schema

  embedded_schema do
    field(:paging, :map)
    field(:results, {:array, :map})
  end

  def new(arg) do
    %__MODULE__{
      paging:
        arg["paging"]
        |> (fn
              arg when is_nil(arg) ->
                nil

              arg ->
                Map.new(arg, fn {k, v} ->
                  {String.to_atom(k), v |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)}
                end)
            end).(),
      results:
        arg["results"]
        |> (fn
              arg when is_nil(arg) -> nil
              arg -> Enum.map(arg, fn result -> HubspotApi.Deal.new(result) end)
            end).()
    }
  end
end
