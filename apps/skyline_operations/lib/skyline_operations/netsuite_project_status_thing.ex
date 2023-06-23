defmodule SkylineOperations.NetsuiteProjectStatus do
  def get_project_status(project) do
    netsuite_project_status =
      SkylineOperations.NetsuiteProjectStatuses.dictionary()[project.custentity_bb_project_status]

    case netsuite_project_status do
      "On-Hold" ->
        {"No Dates needed", "On-Hold"}

      "Cancelled" ->
        {"No Dates needed", "Cancelled"}

      "Completed" ->
        {"No dates needed", "Completed"}

      _ ->
        {%{
           "site_survey_start_date" => project.custentity_bb_site_audit_pack_start_date,
           "site_survey_end_date" => project.custentity_bb_site_audit_pack_end_date,
           "design_start_date" => project.custentity_bb_design_package_start_date,
           "design_end_date" => project.custentity_bb_design_package_end_date,
           "onboarding_start_date" => project.custentity_actgrp_133_start_date,
           "onboarding_end_Date" => project.custentity_actgrp_133_end_date,
           "permit_nma_start_date" => project.custentity_actgrp_119_start_date,
           "permit_nma_end_date" => project.custentity_actgrp_119_end_date,
           "install_start_date" => project.custentity_actgrp_5_start_date,
           "install_end_date" => project.custentity_actgrp_5_end_date,
           "inspection_start_date" => project.custentity_bb_subst_compl_pack_start_dt,
           "inspection_end_date" => project.custentity_bb_subst_compl_pack_end_dt,
           "net_metering_pto_start_date" => project.custentity_actgrp_136_start_date,
           "net_metering_pto_end_date" => project.custentity_actgrp_136_end_date,
           "system_on_start_date" => project.custentity_bb_final_acc_pack_start_date,
           "system_on_end_date" => project.custentity_bb_final_acc_pack_end_date
         }, "No Progress"}
        |> maybe_site_survey()
        |> maybe_design()
        |> maybe_onboarding()
        |> maybe_permitting()
        |> maybe_installing()
        |> maybe_inspecting()
        |> maybe_pto()
        |> maybe_system_on()
    end
  end

  defp maybe_system_on({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In PTO",
          "Inspection Complete"
        ]

    completed_previous_status = "PTO Complete"

    case {
      is_nil(dates["system_on_start_date"]),
      is_nil(dates["system_on_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In System On"}

      {false, false, false, ^completed_previous_status} ->
        {dates, "System On Complete"}

      _ ->
        {dates, status}
    end
  end

  defp maybe_pto({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In Inspection",
          "Installation Complete"
        ]

    completed_previous_status = "Inspection Complete"

    case {
      is_nil(dates["net_metering_pto_start_date"]),
      is_nil(dates["net_metering_pto_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In PTO", previous_statuses}

      {false, false, false, ^completed_previous_status} ->
        {dates, "PTO Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end

  defp maybe_inspecting({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In Installation",
          "Permitting Complete"
        ]

    completed_previous_status = "Installation Complete"

    case {
      is_nil(dates["inspection_start_date"]),
      is_nil(dates["inspection_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In Inspection", previous_statuses}

      {false, false, false, ^completed_previous_status} ->
        {dates, "Inspection Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end

  defp maybe_installing({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In Permitting",
          "Onboarding Complete"
        ]

    completed_previous_status = "Permitting Complete"

    case {
      is_nil(dates["install_start_date"]),
      is_nil(dates["install_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In Installation", previous_statuses}

      {false, false, false, ^completed_previous_status} ->
        {dates, "Installation Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end

  defp maybe_permitting({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In Onboarding",
          "Design Complete"
        ]

    completed_previous_status = "Onboarding Complete"

    case {
      is_nil(dates["permit_nma_start_date"]),
      is_nil(dates["permit_nma_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In Permitting", previous_statuses}

      {false, false, false, ^completed_previous_status} ->
        {dates, "Permitting Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end

  defp maybe_onboarding({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In Design",
          "Site Survey Complete"
        ]

    completed_previous_status = "Design Complete"

    case {
      is_nil(dates["onboarding_start_date"]),
      is_nil(dates["onboarding_end_Date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In Onboarding", previous_statuses}

      {false, false, false, ^completed_previous_status} ->
        {dates, "Onboarding Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end

  defp maybe_design({dates, status, previous_statuses}) do
    previous_statuses =
      previous_statuses ++
        [
          "In Site Survey"
        ]

    completed_previous_status = "Site Survey Complete"

    case {
      is_nil(dates["design_start_date"]),
      is_nil(dates["design_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, false, ^completed_previous_status} ->
        {dates, "In Design", previous_statuses}

      {false, false, false, ^completed_previous_status} ->
        {dates, "Design Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end

  defp maybe_site_survey({dates, status}) do
    previous_statuses =
      [] ++
        [
          "No Progress"
        ]

    case {
      is_nil(dates["site_survey_start_date"]),
      is_nil(dates["site_survey_end_date"]),
      Enum.member?(previous_statuses, status),
      status
    } do
      {false, true, true, "No Progress"} ->
        {dates, "In Site Survey", previous_statuses}

      {false, false, true, "No Progress"} ->
        {dates, "Site Survey Complete", previous_statuses}

      _ ->
        {dates, status, previous_statuses}
    end
  end
end
