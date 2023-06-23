defmodule InfoTech.ItCheckoutForm do
  use Ecto.Schema

  schema "it_checkout_form" do
    field(:employee_first_name, :string)
    field(:employee_last_name, :string)
    field(:checkout_date, :utc_datetime)
    field(:checkin_date, :utc_datetime)
    timestamps()
  end

  def new(args) do
    %__MODULE__{
      employee_first_name: args["employee_first_name"],
      employee_last_name: args["employee_last_name"],
      checkout_date: args["checkout_date"],
      checkin_date: args["checkin_date"]
    }
  end
end
