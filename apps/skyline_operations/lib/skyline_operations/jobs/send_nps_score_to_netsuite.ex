defmodule SkylineOperations.Jobs.SendNPSScoreToNetsuite do
  use Oban.Worker, queue: :skyline_operations

  @doc """
  Used to take an incoming Hubspot NPS score and send to the related Netsuite record
  """
  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"vid" => contact_id}}) do
    with {:ok,
          %{
            body: %{
              "results" => [%{"to" => [%{"id" => deal_id} | _to_tail]} | _associated_deals_tail]
            },
            status: 200
          }} <-
           HubspotApi.fetch_association_contact_to_deal(contact_id)
           |> IO.inspect(label: "Fetch associated deals"),
         local_deal <-
           Repo.get_by(HubspotApi.Deal, hubspot_deal_id: deal_id)
           |> IO.inspect(label: "fetch local deal"),
         netsuite_project_id <-
           local_deal.properties["netsuite_project_id"] |> IO.inspect(label: "local project id"),
         :ok <-
           update_job(
             netsuite_project_id,
             %{
               "custentity_sk_nps_score" =>
                 local_deal.properties["last_nps_survey_rating"]
                 |> (fn
                       string_int when is_nil(string_int) ->
                         raise {:error, "No survey rating"}

                       string_int ->
                         {return_int, _} = string_int |> Integer.parse()
                         return_int
                     end).(),
               "custentity_skl_last_nps_survey_date" =>
                 local_deal.properties["last_nps_survey_date"],
               "custentity_skl_last_nps_survey_comment" =>
                 local_deal.properties["last_nps_survey_comment"]
             }
             |> IO.inspect(label: "update to apply")
           ) do
      {:ok, "Done"}
    else
      e -> {:error, e}
    end
  end

  def update_job(netsuite_project_id, update_data) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(netsuite_project_id, update_data) |> IO.inspect() do
      :ok
    else
      {:ok, %{status: 429}} -> update_job(netsuite_project_id, update_data)
      error -> {:error, error} |> IO.inspect()
    end
  end

  def update_customer(netsuite_customer_id, update_data) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_customer(netsuite_customer_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> update_customer(netsuite_customer_id, update_data)
      error -> {:error, error}
    end
  end
end
