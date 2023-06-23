defmodule SkylineOperations.Jobs.RefreshArrayType do
  @moduledoc """
  Description
  This will find the hubspot deal and associated netsuite records

  Then, it'll query sighten for the array type of the record

  Once it has the array type, it'll update Hubspot and Netsuite

  Steps
  step 1: find hubspot deal
  step 2: find netsuite project
  step 3: find netsuite sub customer
  step 4: find netsuite top customer
  step 5: get sighten site id
  step 6. get sighten contracts
  step 7: get sighten quote id
  step 8: get array type from sighten
  step 9. update hubspot deal
  step 10. update netsuite top customer
  step 11. update netsuite sub customer
  step 12. update netsuite project

  Input
  Hubspot Deal Id
  """
  use Oban.Worker, queue: :long_updater

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"objectId" => hubspot_deal_id} = _incoming_deal}) do
    with {:ok, %HubspotApi.Deal{} = deal} <-
           find_hubspot_deal(hubspot_deal_id)
           |> IO.inspect(label: "step 1: find hubspot deal"),
         {:ok, project} <-
           find_netsuite_project(deal)
           |> IO.inspect(label: "step 2: find netsuite project"),
         {:ok, sub_customer} <-
           find_netsuite_sub_customer(project)
           |> IO.inspect(label: "step 3: find netsuite sub customer"),
         {:ok, top_customer} <-
           find_netsuite_top_customer(sub_customer)
           |> IO.inspect(label: "step 4: find netsuite top customer"),
         sighten_site_id <-
           deal.properties["sighten_site_id"]
           |> IO.inspect(label: "step 5: get sighten site id"),
         {:ok, [sighten_contracts]} <-
           SightenApi.fetch_completed_contract(sighten_site_id)
           |> IO.inspect(label: "step 6. get sighten contracts"),
         sighten_quote_id <-
           sighten_contracts["quote"]
           |> IO.inspect(label: "step 7: get sighten quote id"),
         {:ok, [%{"array_type" => array_types}]} <-
           SightenApi.fetch_array_type(:quote, sighten_quote_id)
           |> IO.inspect(label: "step 8: get array type from sighten"),
         array_types <-
           Enum.uniq(array_types)
           |> Enum.join(", ")
           |> IO.inspect(label: "step 8. get array type from sighten"),
         :ok <-
           force_update_hubspot_deal(deal, %{
             "array_type" => array_types,
             "sighten_quote_id" => sighten_quote_id
           })
           |> IO.inspect(label: "step 9. update hubspot deal"),
         :ok <-
           force_update_netsuite_customer(top_customer, %{
             "custentity_sk_array_type" => array_types,
             "custentity_sk_sighten_site_id" => sighten_site_id,
             "custentity_sk_sighten_quote_id" => sighten_quote_id
           })
           |> IO.inspect(label: "step 10. update netsuite top customer"),
         :ok <-
           force_update_netsuite_customer(sub_customer, %{
             "custentity_sk_array_type" => array_types,
             "custentity_sk_sighten_site_id" => sighten_site_id,
             "custentity_sk_sighten_quote_id" => sighten_quote_id
           })
           |> IO.inspect(label: "step 11. update netsuite sub customer"),
         :ok <-
           force_update_netsuite_job(project, %{
             "custentity_sk_array_type" => array_types,
             "custentity_sk_sighten_site_id" => sighten_site_id,
             "custentity_sk_sighten_quote_id" => sighten_quote_id
           })
           |> IO.inspect(label: "step 12. update netsuite project") do
      {:ok, "Refreshed Array Type for #{hubspot_deal_id}"}
    else
      error -> {:error, error}
    end
  end

  defp force_update_netsuite_job(%NetsuiteApi.Project{} = project, update) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_job(project.netsuite_project_id, update) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_netsuite_job(project.netsuite_project_id, update)
      error -> {:error, error}
    end
  end

  defp force_update_netsuite_customer(%NetsuiteApi.Customer{} = customer, update) do
    with {:ok, %{status: 204}} <-
           NetsuiteApi.update_customer(customer.netsuite_customer_id, update) do
      :ok
    else
      {:ok, %{status: 429}} ->
        force_update_netsuite_customer(customer.netsuite_customer_id, update)

      error ->
        {:error, error}
    end
  end

  defp force_update_hubspot_deal(%HubspotApi.Deal{} = deal, update) do
    with {:ok, %{status: 200}} <-
           HubspotApi.update_deal(deal.hubspot_deal_id, update) do
      :ok
    else
      {:ok, %{status: 429}} -> force_update_hubspot_deal(deal, update)
      error -> {:error, error}
    end
  end

  defp find_netsuite_top_customer(%NetsuiteApi.Customer{} = sub_customer) do
    with top_customer <-
           Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: sub_customer.parent) do
      {:ok, top_customer}
    else
      Ecto.NoResultsError -> {:error, "Could not find top customer"}
      error -> {:error, error}
    end
  end

  defp find_netsuite_sub_customer(%NetsuiteApi.Project{} = project) do
    with sub_customer <- Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: project.parent) do
      {:ok, sub_customer}
    else
      Ecto.NoResultsError -> {:error, "Could not find sub customer"}
      error -> {:error, error}
    end
  end

  defp find_netsuite_project(%HubspotApi.Deal{} = deal) do
    with project <-
           Repo.get_by!(NetsuiteApi.Project,
             netsuite_project_id: deal.properties["netsuite_project_id"]
           ) do
      {:ok, project}
    else
      Ecto.NoResultsError -> {:error, "Could not find netsuite project"}
      error -> {:error, error}
    end
  end

  defp find_hubspot_deal(hubspot_deal_id) do
    with deal <- Repo.get_by!(HubspotApi.Deal, hubspot_deal_id: hubspot_deal_id) do
      {:ok, deal}
    else
      Ecto.NoResultsError -> {:error, "Could not find hubspot deal"}
      error -> {:error, error}
    end
  end
end
