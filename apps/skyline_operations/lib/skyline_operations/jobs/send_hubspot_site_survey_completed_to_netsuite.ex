defmodule SkylineOperations.Jobs.SendSiteSurveyCompletedFromHubspotToNetsuite do
  use Oban.Worker, queue: :skyline_operations

  @impl Oban.Worker
  def perform(%Oban.Job{args: received_body_params, id: oban_job_id, attempt: attempt}) do
    with %{"objectId" => deal_id} <-
           received_body_params
           |> IO.inspect(label: "RECEIVED PARAMS"),
         {:ok, project} <-
           Repo.get_by(NetsuiteApi.Project,
             custentity_skl_hs_dealid: to_string(deal_id)
           )
           |> (fn
                 project when is_nil(project) -> {:error, "Could not find Netsuite Project"}
                 project -> {:ok, project}
               end).()
           |> IO.inspect(label: "RECEIVED PROJECT"),
         sub_customer <-
           Repo.get_by!(NetsuiteApi.Customer,
             netsuite_customer_id: project.parent
           )
           |> IO.inspect(label: "SUB CUSTOMER"),
         top_customer <-
           Repo.get_by!(NetsuiteApi.Customer,
             netsuite_customer_id: sub_customer.parent
           )
           |> IO.inspect(label: "TOP CUSTOMER"),
         {:ok, %{properties: properties}} <-
           HubspotApi.get_deal(deal_id, ["site_survey_completed"])
           |> IO.inspect(label: "FOUND DEAL"),
         hubspot_site_survey_completed_date <-
           properties["site_survey_completed"]
           |> IO.inspect(label: "SITE SURVEY COMPLETED DATE"),
         :ok <-
           update_job(project.netsuite_project_id, %{
             "custentity_sk_site_survey_date" => hubspot_site_survey_completed_date
           })
           |> IO.inspect(label: "UPDATED JOB"),
         :ok <-
           update_customer(project.parent, %{
             "custentity_sk_site_survey_date" => hubspot_site_survey_completed_date
           })
           |> IO.inspect(label: "UPDATED SUB CUSTOMER"),
         :ok <-
           update_customer(top_customer.netsuite_customer_id, %{
             "custentity_sk_site_survey_date" => hubspot_site_survey_completed_date
           })
           |> IO.inspect(label: "UPDATED TOP CUSTOMER") do
      {:ok, "finished"}
    else
      {:error, "Could not find Netsuite Project"} = error ->
        if attempt >= 10 do
          SkylineSlack.send_skycrm_helpdesk_message("""
          *Known SkyCRM error occured while sending site survey completed to Netsuite*
          https://app.hubspot.com/contacts/org/deal/#{received_body_params["objectId"]}

          SkyCRM was not able to find a Netsuite Project associated with this deal.

          If one exists, please find the project in Netsuite then edit it.
          Under "Custom", the field "Hubspot Deal ID" should be filled in with "#{received_body_params["objectId"]}".

          Retry job at the link provided once the fixes have been made.
          https://skycrm.live/a/skyline_oban/live/#{oban_job_id}
          """)

          error
        else
          error
        end

      error ->
        IO.inspect("hello there")
        {:error, error}
    end
  end

  def update_job(netsuite_project_id, update_data) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(netsuite_project_id, update_data) do
      :ok
    else
      {:ok, %{status: 429}} -> update_job(netsuite_project_id, update_data)
      error -> {:error, error}
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
