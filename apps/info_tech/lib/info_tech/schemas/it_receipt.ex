defmodule InfoTech.ItReceipt do
  use Ecto.Schema

  schema "it_receipt" do
    field(:vendor, :string)
    field(:item_cost, :decimal)
    field(:item_tax, :decimal)
    field(:item_cost_with_tax, :decimal)
    field(:item_receipt_file, :binary)
    timestamps()
  end

  def new(args) do
    %__MODULE__{
      vendor: args["vendor"],
      item_cost: args["item_cost"],
      item_tax: args["item_tax"],
      item_cost_with_tax: args["item_cost_with_tax"],
      item_receipt_file: args["item_receipt_file"]
    }
  end
end
