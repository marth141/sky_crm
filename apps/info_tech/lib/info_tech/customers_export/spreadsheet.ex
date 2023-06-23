defmodule InfoTech.CustomersExport.Spreadsheet do
  alias SkylineGoogle.Spreadsheets.Client
  @spreadsheet_id "10kS-ybJPaMcZI85LAGxM9b4qWsKofBB_gsEcEZ1Gd7s"

  def get_at_range(range) do
    Client.get_at_range(@spreadsheet_id, range)
  end

  def set_at_range(range, values) do
    Client.set_at_range(@spreadsheet_id, range, values)
  end
end
