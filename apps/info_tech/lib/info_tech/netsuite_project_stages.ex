defmodule InfoTech.NetsuiteProjectStages do
  def find_in_database() do
    import Ecto.Query

    from(p in NetsuiteApi.Project, where: not is_nil(p.custentity_bb_project_stage_text))
    |> Repo.all()
    |> Enum.uniq_by(fn p -> p.custentity_bb_project_stage_text end)
    |> Enum.map(fn p -> p.custentity_bb_project_stage_text end)
  end

  def stages() do
    [
      "20 Site Survey  Completed",
      "20 Site Survey  In Progress",
      "30 Design & Engineering Completed",
      "30 Design & Engineering In Progress",
      "40 Onboarding Completed",
      "50 NMA & Permitting Completed",
      "50 NMA & Permitting In Progress",
      "70 Install Completed",
      "70 Install In Progress",
      "80 Inspection Completed",
      "80 Inspection In Progress",
      "85 Net Metering / PTO Completed",
      "85 Net Metering / PTO In Progress",
      "90 System On Completed",
      "90 System On In Progress",
      "Cancelled",
      "Completed",
      "In Progress",
      "New",
      "On-Hold"
    ]
  end
end
