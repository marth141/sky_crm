defmodule InfoTech.ItEquipment do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    brand
    serial_number
    model_number
    model_name
    it_checkout_forms
    it_receipts
  )a

  schema "it_equipment" do
    field(:brand, :string)
    field(:serial_number, :string)
    field(:model_number, :string)
    field(:model_name, :string)

    many_to_many(:it_checkout_forms, InfoTech.ItCheckoutForm,
      join_through: "it_equipment_checkout_form"
    )

    many_to_many(:it_receipts, InfoTech.ItReceipt, join_through: "it_equipment_receipt")
    timestamps()
  end

  def new(args) do
    %__MODULE__{
      brand: args["brand"],
      serial_number: args["serial_number"],
      model_number: args["model_number"],
      model_name: args["model_name"]
    }
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
  end
end
