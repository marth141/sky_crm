defmodule SkylineOperations.Jobs.UpdateHubspotWithNetsuiteStatus do
  use Oban.Worker, queue: :long_updater

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params}) do
    do_it(received_body_params)
  end

  def do_it(received_body_params) do
    finished = {:ok, "finished"}

    active_site_survey = ["In Site Survey"]
    active_design = ["Site Survey Complete", "In Design"]
    active_onboarding = ["Design Complete", "In Onboarding"]
    active_permitting = ["Onboarding Complete", "In Permitting"]
    active_installation = ["Permitting Complete", "In Installation"]
    active_inspection = ["Installation Complete", "In Inspection"]
    active_net_metering = ["Inspection Complete", "In PTO"]
    active_system_on = ["PTO Complete", "In System On", "System On Complete"]
    cancelling = ["Cancelled"]
    on_hold = ["On-Hold"]
    completed = ["Completed"]

    with %{"objectId" => deal_id} <- received_body_params,
         result <-
           Repo.get_by!(SkylineOperations.NetsuiteProjectHubspotDealAssociation,
             hubspot_deal_id: deal_id
           ),
         on_hold_reason <-
           SkylineOperations.NetsuiteOnHoldReasonsToHubspotOnHoldReasons.dictionary()[
             (NetsuiteApi.get_repo_job(hubspot_deal_id: deal_id)
              |> List.first()).custentity_bb_on_hold_reason
           ],
         cancellation_reason <-
           SkylineOperations.NetsuiteCancelReasons.dictionary()[
             (NetsuiteApi.get_repo_job(hubspot_deal_id: deal_id)
              |> List.first()).custentity_bb_cancellation_reason
           ],
         local_stage <- result.project_status do
      cond do
        local_stage in on_hold ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223687",
            "pipeline" => "13223681",
            "on_hold_reason" => on_hold_reason,
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in cancelling ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223688",
            "pipeline" => "13223681",
            "cancel_reason" => cancellation_reason,
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in completed ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13224023",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_system_on ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13224023",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_net_metering ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13224022",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_inspection ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223686",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_installation ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223685",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_permitting ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223684",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_onboarding ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223684",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_design ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "13223683",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        local_stage in active_site_survey ->
          handle_updating_hubspot(result, received_body_params, %{
            "dealstage" => "11444574",
            "pipeline" => "13223681",
            "netsuite_project_id" => received_body_params["netsuite_project_id"]
          })

        true ->
          finished
      end
    else
      {:ok, %{status: 429}} ->
        handle_429(received_body_params)

      error ->
        {:error, error}
    end
  end

  # TODO
  defp handle_updating_hubspot(result, received_body_params, update_obj) do
    finished = {:ok, "finished"}

    with {:ok, %{status: 200}} <-
           HubspotApi.update_deal(result.hubspot_deal_id, update_obj) do
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
