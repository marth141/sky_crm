defmodule CopperApi.CustomFields do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that would collect customfields from Copper and store them in the local postgres.
  """
  use GenServer
  alias CopperApi.Schemas.CustomFieldDefinition, as: CopperCustomFieldDef
  import Ex2ms

  def list_custom_fields() do
    :ets.select(:copper_custom_fields, match_all_without_view_state())
  end

  defp match_all_without_view_state() do
    fun do
      {key, value} when key != :view_state -> value
    end
  end

  # GenServer (Functions)

  def start_link(_) do
    GenServer.start_link(
      # module genserver will call
      __MODULE__,
      # init params
      [],
      name: __MODULE__
    )
  end

  # GenServer (Callbacks)

  def init(_opts) do
    tid = :ets.new(:copper_custom_fields, [:named_table, :set, :public, read_concurrency: true])
    :ets.insert(:copper_custom_fields, {:view_state, default_view_state()})
    {:ok, %{tid: tid, last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    try do
      refresh_cache()
      {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    rescue
      _e ->
        schedule_poll()
        {:noreply, state}
    end
  end

  def handle_call({:get_custom_field_definition_id_by_name, name}, _caller, state) do
    {:reply, CopperApi.Queries.Get.custom_field_definition_id_by_name(name), state}
  end

  def handle_call(
        {:get_custom_field_dropdown_value_id_by_name, field_name, value},
        _caller,
        state
      ) do
    {:reply, CopperApi.Queries.Get.custom_field_dropdown_value_id_by_name(field_name, value),
     state}
  end

  # Private Helpers

  defp insert_to_ets(%CopperCustomFieldDef{id: id} = custom_field) do
    :ets.insert(:copper_custom_fields, {id, custom_field})
  end

  defp default_view_state,
    do: %{
      example: 0
    }

  defp refresh_cache() do
    custom_fields = fetch_custom_fields_from_copper()
    Enum.each(custom_fields, &insert_to_ets/1)

    Messaging.publish(
      "CopperApi",
      :copper_custom_field_updated
    )

    IO.puts("\n \n ======= Copper Custom Fields Refreshed ======= \n \n")
    schedule_poll()
    :ok
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.hours(24))
  end

  def current_date() do
    Timex.now("America/Denver")
    |> Timex.to_date()
  end

  defp fetch_custom_fields_from_copper() do
    CopperApi.list_custom_fields()
  end
end
