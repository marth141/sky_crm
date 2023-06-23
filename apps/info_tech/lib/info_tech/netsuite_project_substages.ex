defmodule InfoTech.NetsuiteProjectSubStages do
  def find_in_database() do
    import Ecto.Query

    from(p in NetsuiteApi.Project, where: not is_nil(p.custentity_bb_project_sub_stage_text))
    |> Repo.all()
    |> Enum.uniq_by(fn p -> p.custentity_bb_project_sub_stage_text end)
    |> Enum.map(fn p -> p.custentity_bb_project_sub_stage_text end)
  end

  def list() do
    [
      "80 Final Electrical Inspection: Inspection Fixes Needed",
      "30 Working",
      "NULL",
      "80 Submit Revised Plans: Ready to Start",
      "Working",
      "80 Final Electrical Inspection: Inspection Scheduled",
      "20 Working",
      "50 Apply for Permit: Needs More Info",
      "90 Energize System: In Progess",
      "50 Apply for Permit: Complete",
      "50 Apply for Permit: Submitted",
      "85 Submit PTO with Loan Company: Ready to Start",
      "70 : Complete",
      "90 NPS Survey: Ready to Start",
      "80 Submit Revised Plans: Complete",
      "90 NPS Survey: Complete",
      "80 Final Electrical Inspection: Ready to Start",
      "80 Final Electrical Inspection: Complete",
      "85 Submit Net Metering: Submitted",
      "30 CAD Design: Ready to Start",
      "90 Energize System: Rejected",
      "70 Electrical Install: Additional Work Needed",
      "50 Apply for NMA: Submitted",
      "30 Send to Engineering: Ready to Start",
      "50 Apply for Permit: Ready to Start",
      "80 Make Design Revisions to Match Job: Inspection Fixes Needed",
      "70 Trigger Funding: Scheduled",
      "80 Final Electrical Inspection: Not Started",
      "50 Apply for NMA: Needs More Info",
      "50 Apply for NMA: Complete",
      "70 Commission System: Ready to Start",
      "85 Submit Net Metering: Ready to Start",
      "50 Apply for NMA: Ready to Start",
      "50 Help with HOA: Ready to Start",
      "85 Submit Net Metering: Rejected",
      "30 Order Equipment: Complete",
      "70 Roof/Ground Install: Complete",
      "50 Apply for NMA: Rejected",
      "90 Customer Solar Setup: Ready to Start",
      "50 Apply for Permit: Rejected",
      "30 Order Placards: Ready to Start",
      "30 Order Placards: Complete",
      "30 CAD Review: Ready to Start",
      "30 Send to Engineering: Complete",
      "30 CAD Review: Revisions Needed",
      "80 Make Design Revisions to Match Job: Ready to Start",
      "20 Site Survey: Needs More Info"
    ]
  end
end
