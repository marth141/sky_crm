defmodule SkylineOperations.Jobs.UpdateCancelledJobFromHubspotToNetsuite do
  use Oban.Worker, queue: :skyline_operations

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    do_it(received_body_params)
  end

  def do_it(received_body_params) do
    finished = {:ok, "finished"}

    try do
      with %{"objectId" => deal_id} <- received_body_params,
           result <-
             Repo.get_by!(SkylineOperations.NetsuiteProjectHubspotDealAssociation,
               hubspot_deal_id: deal_id
             ),
           {:ok, %{properties: properties}} <-
             HubspotApi.get_deal(deal_id, ["dealstage"]),
           deal_stage <- properties["dealstage"] do
        case deal_stage do
          "13223688" ->
            handle_updating_netsuite(result, received_body_params)

          "closedlost" ->
            handle_updating_netsuite(result, received_body_params)
        end

        finished
      else
        {:ok, %{status: 429}} ->
          handle_429(received_body_params)

        error ->
          {:error, error}
      end
    rescue
      _e in Ecto.NoResultsError -> finished
      e -> {:error, e}
    end
  end

  defp handle_updating_netsuite(result, received_body_params) do
    finished = {:ok, "finished"}

    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(result.netsuite_project_id, %{
             "custentity_bb_project_status" => "4"
           }) do
      finished
    else
      {:ok, %{status: 429}} ->
        handle_429(received_body_params)

      error ->
        {:error, error}
    end
  end

  defp handle_429(received_body_params) do
    Process.sleep(60000)
    do_it(received_body_params)
  end
end
