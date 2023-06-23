defmodule SkylineSales.SalesPipeline do
  def dictionary() do
    %{
      "12064513" => "Credit Approved - Pending Docs",
      "14426650" => "Proposal Requested - Pending Design",
      "appointmentscheduled" => "Design Complete - Pending Review",
      "closedlost" => "Closed-Lost",
      "closedwon" => "Closed-Won",
      "decisionmakerboughtin" => "Proposal Reviewed - Pending Approval",
      "default" => "Sales Pipeline"
    }
  end
end
