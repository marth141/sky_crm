defmodule SkylineOperations.CasePriority do
  def id_dictionary() do
    %{
      "1" => "High",
      "2" => "Medium",
      "3" => "Low"
    }
  end

  def name_dictionary() do
    %{
      "LOW" => "3",
      "MEDIUM" => "2",
      "HIGH" => "1"
    }
  end
end
