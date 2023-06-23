defmodule InfoTech.CustomersExport.Spreadsheet.InputSheet do
  alias InfoTech.CustomersExport.Spreadsheet
  @sheet_name "Copy of Customers 0-10 and 12 - Customer Life-Cycle 2!"

  def get_at_range(range) do
    Spreadsheet.get_at_range(@sheet_name <> range)
  end

  def set_at_range(range, values) do
    Spreadsheet.set_at_range(@sheet_name <> range, values)
  end
end
