defmodule SkylineOperations.PaymentSchedule do
  def dictionary() do
    %{
      "Service Finance" => "1",
      "LoanPal" => "2",
      "GoodLeap" => "2",
      "Sunlight" => "3",
      "CASH" => "4"
    }
  end

  def id_dictionary() do
    %{
      "1" => "Service Finance",
      "2" => ["LoanPal", "GoodLeap"],
      "3" => "Sunlight",
      "4" => "CASH"
    }
  end
end
