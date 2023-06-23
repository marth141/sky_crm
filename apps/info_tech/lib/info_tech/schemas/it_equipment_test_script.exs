alias InfoTech.{ItEquipment, ItEquipmentReceipt, ItEquipmentCheckoutForm}

# Step 1. Make some IT equipment.
attrs = %{
  brand: "Apple",
  serial_number: "FVFFCXCGQ05D",
  model_number: "A2338",
  model_name: "MacBook Pro"
}

equipment_changeset = ItEquipment.changeset(%ItEquipment{}, attrs)

db_equipment = Repo.insert!(equipment_changeset)

db_equipment = Repo.get!(ItEquipment, db_equipment.id)

# Step 2. Add a receipt to the added IT equipment.
receipt =
  Ecto.build_assoc(db_equipment, :it_equipment_receipt, %{
    vendor: "Amazon",
    item_cost: 1199.00,
    item_tax: 56.35,
    item_cost_with_tax: 1255.35,
    item_receipt_file: File.read!("elite_dangerous_wallpaper.jpg"),
    it_equipment: db_equipment
  })

db_receipt = Repo.insert!(receipt)

db_equipment = Repo.get!(ItEquipment, db_equipment.id)

# Step 3. Add n checkout forms to the IT equipment.
checkout_form =
  Ecto.build_assoc(db_equipment, :it_equipment_checkout_form, %{
    employee_first_name: "Nathan",
    employee_last_name: "Casados",
    checkout_date: DateTime.utc_now() |> DateTime.truncate(:second),
    checkin_date: DateTime.utc_now() |> DateTime.truncate(:second),
    it_equipment: db_equipment
  })

db_checkout_form = Repo.insert!(checkout_form)

db_equipment = Repo.get!(ItEquipment, db_equipment.id)

# Step 4. Add 2nd Checkout Form.
checkout_form =
  Ecto.build_assoc(db_equipment, :it_equipment_checkout_form, %{
    employee_first_name: "David",
    employee_last_name: "Shake",
    checkout_date: DateTime.utc_now() |> DateTime.truncate(:second),
    checkin_date: DateTime.utc_now() |> DateTime.truncate(:second),
    it_equipment: db_equipment
  })

db_checkout_form = Repo.insert!(checkout_form)

db_equipment = Repo.get!(ItEquipment, db_equipment.id)

Repo.all(ItEquipment) |> Repo.preload([:it_equipment_checkout_form, :it_equipment_receipt])
