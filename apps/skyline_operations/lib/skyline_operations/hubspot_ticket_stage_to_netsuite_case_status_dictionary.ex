defmodule SkylineOperations.HubspotTicketPostSaleStageToNetsuiteCaseStatus do
  def hubspot_to_netsuite_dictionary() do
    %{
      "13033842" => SkylineOperations.CaseStatuses.name_dictionary()["Not Started"],
      "13033843" => SkylineOperations.CaseStatuses.name_dictionary()["In Progress"],
      "13867588" => SkylineOperations.CaseStatuses.name_dictionary()["Escalated"],
      "13884847" => SkylineOperations.CaseStatuses.name_dictionary()["Re-Opened"],
      "13033845" => SkylineOperations.CaseStatuses.name_dictionary()["Closed"],
      "17947912" => SkylineOperations.CaseStatuses.name_dictionary()["Work Order Scheduled"],
      "17947913" => SkylineOperations.CaseStatuses.name_dictionary()["Parts Ordered"]
    }
  end

  def netsuite_to_hubspot_dictionary() do
    %{
      "1" => "13033842",
      "2" => "13033843",
      "3" => "13867588",
      "4" => "13884847",
      "5" => "13033845",
      "6" => "17947912",
      "7" => "17947913"
    }
  end
end
