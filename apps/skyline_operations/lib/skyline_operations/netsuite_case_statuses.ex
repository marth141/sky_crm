defmodule SkylineOperations.CaseStatuses do
  def id_dictionary() do
    %{
      "1" => "Not Started",
      "2" => "In Progress",
      "3" => "Escalated",
      "4" => "Re-Opened",
      "5" => "Closed",
      "6" => "Work Order Scheduled",
      "7" => "Parts Ordered",
      "8" => "Needs Work Order Scheduled",
      "9" => "Needs Approved Contractor",
      "10" => "Customer Unresponsive",
      "11" => "Work Order Completed"
    }
  end

  def name_dictionary() do
    %{
      "Not Started" => "1",
      "In Progress" => "2",
      "Escalated" => "3",
      "Re-Opened" => "4",
      "Closed" => "5",
      "Work Order Scheduled" => "6",
      "Parts Ordered" => "7",
      "Needs Work Order Scheduled" => "8",
      "Needs Approved Contractor" => "9",
      "Customer Unresponsive" => "10",
      "Work Order Completed" => "11"
    }
  end
end
