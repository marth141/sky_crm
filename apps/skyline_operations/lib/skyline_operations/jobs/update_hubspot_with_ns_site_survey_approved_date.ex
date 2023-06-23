defmodule SkylineOperations.Jobs.UpdateHubspotWithNetsuiteSiteSurveyApprovedDate do
  use Oban.Worker, queue: :long_updater

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    do_it(received_body_params)
  end

  def do_it(received_body_params) do
    finished = {:ok, "finished"}

    with %{"objectId" => deal_id} <- received_body_params,
         result <-
           Repo.get_by!(SkylineOperations.NetsuiteProjectHubspotDealAssociation,
             hubspot_deal_id: deal_id
           ),
         project <-
           Repo.get_by!(NetsuiteApi.Project,
             netsuite_project_id: Integer.to_string(result.netsuite_project_id)
           ),
         site_survey_approved_date <-
           project.custentity_bb_site_audit_pack_end_date,
         {:ok, "finished"} <-
           handle_updating_hubspot(deal_id, site_survey_approved_date, received_body_params) do
      finished
    else
      {:ok, %{status: 429}} ->
        handle_429(received_body_params)

      error ->
        {:error, error}
    end
  end

  # TODO
  defp handle_updating_hubspot(deal_id, site_survey_approved_date, received_body_params) do
    finished = {:ok, "finished"}

    with {:ok, %{status: 200}} <-
           HubspotApi.update_deal(deal_id, %{
             "site_survey_approved" =>
               site_survey_approved_date
               |> (fn
                     date when is_nil(date) -> date
                     date -> DateTimeParser.parse!(date)
                   end).()
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
