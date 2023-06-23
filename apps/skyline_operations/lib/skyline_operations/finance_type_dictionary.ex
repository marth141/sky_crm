defmodule SkylineOperations.FinancingType do
  def dictionary() do
    %{
      "Service Finance" => "2",
      "LoanPal" => "2",
      "GoodLeap" => "2",
      "Sunlight" => "2",
      "CASH" => "1"
    }
  end

  def id_dictionary() do
    %{
      "1" => "Cash",
      "2" =>
        {"loans",
         [
           "Service Finance",
           "LoanPal",
           "GoodLeap",
           "Sunlight",
           "Cash"
         ]}
    }
  end
end
