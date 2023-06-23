defmodule InfoTech.CustomersExport do
  use GenServer
  import Ecto.Query
  alias CopperApi.Schemas.Opportunity
  alias CopperApi.Schemas.People
  alias CopperApi.Queries.Get

  def export_to_google_sheet() do
    to_google_sheets =
      get_customers_this_week()
      |> Task.async_stream(fn %Opportunity{primary_contact_id: primary_contact_id} = opportunity ->
        with %People{
               address: %{
                 "city" => city,
                 "country" => country,
                 "postal_code" => postal_code,
                 "state" => state,
                 "street" => street
               }
             } = person <- CopperApi.People.fetch(primary_contact_id) do
          [
            person.name,
            opportunity.close_date |> TimeApi.from_unix() |> Timex.format!("{YYYY}-{M}-{D}"),
            [
              if(is_nil(street), do: "Missing Street, ", else: street <> ", "),
              if(is_nil(city), do: "Missing City, ", else: city <> ", "),
              if(is_nil(state), do: "Missing State, ", else: state <> ", "),
              if(is_nil(postal_code), do: "Missing Postal Code, ", else: postal_code <> ", "),
              if(is_nil(country), do: "Missing Country, ", else: country <> ", ")
            ]
            |> List.to_string()
          ]
        else
          _ -> nil
        end
      end)
      |> Stream.map(fn {:ok, thing} -> thing end)
      |> Enum.to_list()

    InfoTech.CustomersExport.Spreadsheet.InputSheet.set_at_range("A2:C", to_google_sheets)
  end

  def get_customers_this_week() do
    pipeline_stages = [
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "0 Closed-Won"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "1 Onboarding"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "2 CADs & Engineering"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "3 Net Meter App & Permitting"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "4 Awaiting Installation"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "5 Installation/Funding"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "6 Multi-step Installation/Funding"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "7 Final Inspections"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "8 Net-metering"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "9 System On"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "10 Rebate Prep"),
      Get.pipeline_stage_id_by_name("Customer Life-Cycle", "12 On Hold")
    ]

    statuses = [
      "Lost",
      "Open",
      "Won"
    ]

    start_of_week = TimeApi.start_of_week() |> TimeApi.to_unix()
    end_of_week = TimeApi.end_of_week() |> TimeApi.to_unix()

    query =
      from(o in Opportunity,
        where:
          o.pipeline_stage_id in ^pipeline_stages and o.status in ^statuses and
            o.close_date >= ^start_of_week and o.close_date <= ^end_of_week
      )

    Opportunity.read(query)
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
    {:ok, %{last_refresh: nil}, {:continue, :init}}
  end

  def handle_info(:refresh_view, state) do
    export_to_google_sheet()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_continue(:init, state) do
    schedule_poll()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  defp schedule_poll do
    Process.send_after(self(), :refresh_view, :timer.minutes(10))
  end
end
