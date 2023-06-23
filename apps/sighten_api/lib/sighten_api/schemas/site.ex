defmodule SightenApi.Schemas.Site do
  defstruct ~w(
    address
    archive_reason
    archived
    building_type
    contacts
    created_by
    date_created
    date_updated
    estimated_contract_start_date
    external_programs
    federal_tax_rate
    follow_up_date
    follow_up_notification_date
    job_type
    lead_source
    modified_by
    note
    npv_yearly_discount_rate
    owned_by_organization
    primary_language
    property_tax_rate
    retrofit
    salesworkflow
    square_footage
    state_tax_rate
    usage_profile
    uuid
  )a

  def new(arg) do
    %__MODULE__{
      address: arg["address"] |> SightenApi.Schemas.Site.Address.new(),
      archive_reason: arg["archive_reason"],
      archived: arg["archived"],
      building_type: arg["building_type"],
      contacts:
        arg["contacts"]
        |> (fn
              nil ->
                []

              [] ->
                []

              list ->
                Enum.map(list, fn contact -> SightenApi.Schemas.Site.Contact.new(contact) end)
            end).(),
      created_by: arg["created_by"],
      date_created: arg["date_created"],
      date_updated: arg["date_updated"],
      estimated_contract_start_date: arg["estimated_contract_start_date"],
      external_programs: arg["external_programs"],
      federal_tax_rate: arg["federal_tax_rate"],
      follow_up_date: arg["follow_up_date"],
      follow_up_notification_date: arg["follow_up_notification_date"],
      job_type: arg["job_type"],
      lead_source: arg["lead_source"],
      modified_by: arg["modified_by"],
      note: arg["note"],
      npv_yearly_discount_rate: arg["npv_yearly_discount_rate"],
      owned_by_organization: arg["owned_by_organization"],
      primary_language: arg["primary_language"],
      property_tax_rate: arg["property_tax_rate"],
      retrofit: arg["retrofit"],
      salesworkflow: arg["salesworkflow"],
      square_footage: arg["square_footage"],
      state_tax_rate: arg["state_tax_rate"],
      usage_profile: arg["usage_profile"],
      uuid: arg["uuid"]
    }
  end
end
