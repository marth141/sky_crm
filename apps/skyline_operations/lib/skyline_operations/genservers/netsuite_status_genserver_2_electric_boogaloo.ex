defmodule SkylineOperations.NetsuiteStatusGenserver2ElectricBoogaloo do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  A genserver that takes projets from Netsuite and updates the hubspot

  """
  use GenServer

  # GenServer (Functions)

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  # GenServer (Callbacks)

  def init(_opts) do
    case Application.get_env(:skyline_operations, :env) do
      :dev ->
        {:ok, %{last_refresh: nil}}

      :test ->
        {:ok, %{last_refresh: nil}}

      :prod ->
        NetsuiteApi.subscribe()
        {:ok, %{last_refresh: nil}}
    end
  end

  def handle_info(:netsuite_projects_updated, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def refresh_cache() do
    get_all_projects()
    |> Task.async_stream(&make_hubspot_deal_update/1, timeout: :infinity)
    |> Enum.to_list()

    IO.puts("\n \n ======= Netsuite Status Refreshed ======= \n \n")
    :ok
  end

  defp make_hubspot_deal_update({:ok, %SkylineOperations.Project{} = project})
       when project.netsuite_project_status == "Working" do
    update = %{
      "netsuite_project_id" => project.netsuite_project_id,
      "netsuite_customer_id" => project.netsuite_customer_id,
      "pipeline" => get_from_dictionary(:pipeline_id, project.netsuite_project_stage),
      "dealstage" =>
        project
        |> (fn
              %SkylineOperations.Project{} = project
              when project.netsuite_project_stage == "On-Hold" or
                     project.netsuite_project_stage == "Cancelled" ->
                project
                |> (fn
                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_system_on_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "90 System On Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_net_metering_pto_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "80 Net Metering / PTO Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_inspection_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "70 Inspection Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_install_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "60 Install Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_nma_permitting_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "50 NMA & Permitting Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_design_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "30 Design & Engineering Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when not is_nil(project.netsuite_site_survey_completed_date) ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "20 Site Survey  Completed"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when project.netsuite_project_stage == "On-Hold" ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "On-Hold"
                        ].stage_id

                      %SkylineOperations.Project{} = project
                      when project.netsuite_project_stage == "Cancelled" ->
                        SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
                          "Cancelled"
                        ].stage_id
                    end).()

              %SkylineOperations.Project{} = project ->
                get_from_dictionary(:stage_id, project.netsuite_project_stage)
            end).(),
      "site_survey_approved" => project.netsuite_site_survey_completed_date,
      "design_completed_date" => project.netsuite_design_completed_date,
      "nma_permitting_completed_date" => project.netsuite_nma_permitting_completed_date,
      "install_date" => project.netsuite_install_completed_date,
      "inspection_completed_date" => project.netsuite_inspection_completed_date,
      "net_metering_pto_completed_date" => project.netsuite_net_metering_pto_completed_date,
      "system_on_date" => project.netsuite_system_on_completed_date
    }

    update_hubspot_deal(project, update)
  end

  defp make_hubspot_deal_update({:ok, %SkylineOperations.Project{} = project})
       when project.netsuite_project_status == "Completed" do
    update = %{
      "netsuite_project_id" => project.netsuite_project_id,
      "netsuite_customer_id" => project.netsuite_customer_id,
      "pipeline" => get_from_dictionary(:pipeline_id, project.netsuite_project_stage),
      "dealstage" => get_from_dictionary(:stage_id, project.netsuite_project_stage),
      "site_survey_approved" => project.netsuite_site_survey_completed_date,
      "design_completed_date" => project.netsuite_design_completed_date,
      "nma_permitting_completed_date" => project.netsuite_nma_permitting_completed_date,
      "install_date" => project.netsuite_install_completed_date,
      "inspection_completed_date" => project.netsuite_inspection_completed_date,
      "net_metering_pto_completed_date" => project.netsuite_net_metering_pto_completed_date,
      "system_on_date" => project.netsuite_system_on_completed_date
    }

    update_hubspot_deal(project, update)
  end

  defp make_hubspot_deal_update({:ok, %SkylineOperations.Project{} = project})
       when project.netsuite_project_status == "On-Hold" do
    update = %{
      "netsuite_project_id" => project.netsuite_project_id,
      "netsuite_customer_id" => project.netsuite_customer_id,
      "pipeline" => get_from_dictionary(:pipeline_id, project.netsuite_project_status),
      "dealstage" => get_from_dictionary(:stage_id, project.netsuite_project_status),
      "site_survey_approved" => project.netsuite_site_survey_completed_date,
      "design_completed_date" => project.netsuite_design_completed_date,
      "nma_permitting_completed_date" => project.netsuite_nma_permitting_completed_date,
      "install_date" => project.netsuite_install_completed_date,
      "inspection_completed_date" => project.netsuite_inspection_completed_date,
      "net_metering_pto_completed_date" => project.netsuite_net_metering_pto_completed_date,
      "system_on_date" => project.netsuite_system_on_completed_date,
      "on_hold_reason" =>
        SkylineOperations.NetsuiteOnHoldReasonsToHubspotOnHoldReasons.dictionary()[
          project.netsuite_on_hold_reason
        ],
      "on_hold_description" => project.netsuite_on_hold_comment
    }

    update_hubspot_deal(project, update)
  end

  defp make_hubspot_deal_update({:ok, %SkylineOperations.Project{} = project})
       when project.netsuite_project_status == "Cancelled" do
    update = %{
      "netsuite_project_id" => project.netsuite_project_id,
      "netsuite_customer_id" => project.netsuite_customer_id,
      "pipeline" => get_from_dictionary(:pipeline_id, project.netsuite_project_status),
      "dealstage" => get_from_dictionary(:stage_id, project.netsuite_project_status),
      "site_survey_approved" => project.netsuite_site_survey_completed_date,
      "design_completed_date" => project.netsuite_design_completed_date,
      "nma_permitting_completed_date" => project.netsuite_nma_permitting_completed_date,
      "install_date" => project.netsuite_install_completed_date,
      "inspection_completed_date" => project.netsuite_inspection_completed_date,
      "net_metering_pto_completed_date" => project.netsuite_net_metering_pto_completed_date,
      "system_on_date" => project.netsuite_system_on_completed_date,
      "cancel_reason" =>
        SkylineOperations.NetsuiteCancelReasons.dictionary()[
          project.netsuite_cancellation_reason
        ]
    }

    update_hubspot_deal(project, update)
  end

  defp make_hubspot_deal_update({:ok, %SkylineOperations.Project{} = project})
       when is_nil(project.netsuite_project_status) do
    update = %{
      "netsuite_project_id" => project.netsuite_project_id,
      "netsuite_customer_id" => project.netsuite_customer_id,
      "pipeline" => get_from_dictionary(:pipeline_id, project.netsuite_project_stage),
      "dealstage" => get_from_dictionary(:stage_id, project.netsuite_project_stage),
      "site_survey_approved" => project.netsuite_site_survey_completed_date,
      "design_completed_date" => project.netsuite_design_completed_date,
      "nma_permitting_completed_date" => project.netsuite_nma_permitting_completed_date,
      "install_date" => project.netsuite_install_completed_date,
      "inspection_completed_date" => project.netsuite_inspection_completed_date,
      "net_metering_pto_completed_date" => project.netsuite_net_metering_pto_completed_date,
      "system_on_date" => project.netsuite_system_on_completed_date
    }

    update_hubspot_deal(project, update)
  end

  defp update_hubspot_deal(project, update) do
    with {:ok, %{status: 200}} <-
           HubspotApi.update_deal(project.hubspot_deal_id, update) do
      {:ok, "Updated #{project.hubspot_deal_id}"}
    else
      {:ok, %{status: 429}} -> update_hubspot_deal(project, update)
      {:ok, %{status: 400}} -> "Deal not found #{project.hubspot_deal_id}"
      {:ok, %{status: 405}} -> "Method problem #{project.hubspot_deal_id}"
      error -> {:error, error}
    end
  end

  defp get_from_dictionary(_atom, status) when is_nil(status), do: status

  defp get_from_dictionary(atom, status) do
    SkylineOperations.NetsuiteStagesToHubspotStages.dictionary()[
      status
    ][atom]
  end

  @doc """
  Gets all of the projects and their statuses and stages to update hubspot with
  """
  def get_all_projects do
    import Ecto.Query

    Repo.all(
      from(p in NetsuiteApi.Project,
        select: %SkylineOperations.Project{
          netsuite_project_id: p.netsuite_project_id,
          netsuite_customer_id: p.parent,
          hubspot_deal_id: p.custentity_skl_hs_dealid,
          netsuite_project_status: p.custentity_bb_project_status,
          netsuite_project_stage: p.custentity_bb_project_stage_text,
          netsuite_project_substage: p.custentity_bb_project_sub_stage_text,
          netsuite_site_survey_completed_date: p.custentity_bb_site_audit_pack_end_date,
          netsuite_design_completed_date: p.custentity_bb_design_package_end_date,
          netsuite_nma_permitting_completed_date: p.custentity_actgrp_119_end_date,
          netsuite_install_completed_date: p.custentity_actgrp_5_end_date,
          netsuite_inspection_completed_date: p.custentity_bb_subst_compl_pack_end_dt,
          netsuite_net_metering_pto_completed_date: p.custentity_actgrp_136_end_date,
          netsuite_system_on_completed_date: p.custentity_bb_final_acc_pack_end_date,
          netsuite_on_hold_reason: p.custentity_bb_on_hold_reason,
          netsuite_cancellation_reason: p.custentity_bb_cancellation_reason,
          netsuite_on_hold_comment: p.custentity_skl_on_hold_comment
        },
        order_by: p.netsuite_project_id
      )
    )
    |> Task.async_stream(
      fn project ->
        project
        |> Map.update!(
          :netsuite_customer_id,
          fn
            sub_customer_id when is_nil(sub_customer_id) ->
              sub_customer_id

            sub_customer_id ->
              with %NetsuiteApi.Customer{} = sub_customer <-
                     Repo.get_by!(NetsuiteApi.Customer, netsuite_customer_id: sub_customer_id) do
                sub_customer.parent
              else
                %Ecto.NoResultsError{} -> nil
              end
          end
        )
        |> parse_project_dates()
        |> Map.update!(:netsuite_project_status, &parse_netsuite_project_status/1)
      end,
      timeout: :infinity
    )
  end

  defp parse_project_dates(project) do
    project
    |> Map.update!(:netsuite_site_survey_completed_date, &parse_to_datetime/1)
    |> Map.update!(:netsuite_design_completed_date, &parse_to_datetime/1)
    |> Map.update!(:netsuite_nma_permitting_completed_date, &parse_to_datetime/1)
    |> Map.update!(:netsuite_install_completed_date, &parse_to_datetime/1)
    |> Map.update!(:netsuite_inspection_completed_date, &parse_to_datetime/1)
    |> Map.update!(:netsuite_net_metering_pto_completed_date, &parse_to_datetime/1)
    |> Map.update!(:netsuite_system_on_completed_date, &parse_to_datetime/1)
  end

  def get_one_project do
    import Ecto.Query

    Repo.all(
      from(p in NetsuiteApi.Project,
        select: %SkylineOperations.Project{
          netsuite_project_id: p.netsuite_project_id,
          hubspot_deal_id: p.custentity_skl_hs_dealid,
          netsuite_project_status: p.custentity_bb_project_status,
          netsuite_project_stage: p.custentity_bb_project_stage_text,
          netsuite_project_substage: p.custentity_bb_project_sub_stage_text,
          netsuite_site_survey_completed_date: p.custentity_bb_site_audit_pack_end_date,
          netsuite_design_completed_date: p.custentity_bb_design_package_end_date,
          netsuite_nma_permitting_completed_date: p.custentity_actgrp_119_end_date,
          netsuite_install_completed_date: p.custentity_actgrp_5_end_date,
          netsuite_inspection_completed_date: p.custentity_bb_subst_compl_pack_end_dt,
          netsuite_net_metering_pto_completed_date: p.custentity_actgrp_136_end_date,
          netsuite_system_on_completed_date: p.custentity_bb_final_acc_pack_end_date,
          netsuite_on_hold_reason: p.custentity_bb_on_hold_reason,
          netsuite_cancellation_reason: p.custentity_bb_cancellation_reason,
          netsuite_on_hold_comment: p.custentity_skl_on_hold_comment
        },
        order_by: [desc: p.netsuite_project_id],
        where:
          p.netsuite_project_id in [
            272_831
          ]
      )
    )
    |> Task.async_stream(fn project ->
      project
      |> parse_project_dates()
      |> Map.update!(:netsuite_project_status, &parse_netsuite_project_status/1)
    end)
  end

  defp parse_netsuite_project_status(value) do
    SkylineOperations.NetsuiteProjectStatuses.dictionary()[value]
  end

  defp parse_to_datetime(value) when is_nil(value) do
    value
  end

  defp parse_to_datetime(value) do
    value
    |> TimeApi.parse_to_date()
  end
end
