defmodule NetsuiteApi.Customer do
  @moduledoc """
  This is used to describe a Netsuite Customer with Ecto Schemas
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    alcoholrecipienttype
    altname
    altphone
    balancesearch
    category
    companyname
    consolbalancesearch
    consoldaysoverduesearch
    consoloverduebalancesearch
    consolunbilledorderssearch
    creditholdoverride
    currency
    custentity2
    custentity_bb_entity_latitude_text
    custentity_bb_entity_longitude_text
    custentity_bb_fin_install_per_watt_amt
    custentity_bb_fin_orig_base_per_watt_amt
    custentity_bb_fin_prelim_purch_price_amt
    custentity_bb_financier_customer
    custentity_bb_financier_payment_schedule
    custentity_bb_financing_type
    custentity_bb_home_owner_name_text
    custentity_bb_home_owner_phone
    custentity_bb_home_owner_primary_email
    custentity_bb_homeowner_association
    custentity_bb_install_address_1_text
    custentity_bb_install_address_2_text
    custentity_bb_install_city_text
    custentity_bb_install_state
    custentity_bb_install_zip_code_text
    custentity_bb_inverter_quantity_num
    custentity_bb_is_address_rec_boolean
    custentity_bb_lead_start_date
    custentity_bb_module_quantity_num
    custentity_bb_ob_project_uuid
    custentity_bb_project
    custentity_bb_spouse_name
    custentity_bb_started_from_proj_template
    custentity_bb_system_size_decimal
    custentity_bb_utility_company
    custentity_bb_warehouse_location
    custentity_bbss_configuration
    custentity_bluchat_full_mention_list
    custentity_sk_array_type
    custentity_sk_battery_model
    custentity_sk_cash_back
    custentity_sk_closing_customer_notes
    custentity_sk_critter_guard
    custentity_sk_derate_breaker
    custentity_sk_ev_charger
    custentity_sk_extended_invertery_warrant
    custentity_sk_extended_product
    custentity_sk_finance_term_length
    custentity_sk_hoi_received
    custentity_sk_interest_rate
    custentity_sk_inverter_model
    custentity_sk_led
    custentity_sk_main_panel_upgrade
    custentity_sk_meter_combine
    custentity_sk_meter_upgrade
    custentity_sk_module_model
    custentity_sk_module_size
    custentity_sk_number_of_arrays
    custentity_sk_panel_skirts
    custentity_sk_premium_panels
    custentity_sk_proposal_link
    custentity_sk_roof_pitch
    custentity_sk_roof_reinforcement
    custentity_sk_roof_repairs
    custentity_sk_site_survey_date
    custentity_sk_sales_rep
    custentity_sk_smart_thermostat
    custentity_sk_tree_trimming
    custentity_sk_trenching_ground_type
    custentity_sk_trenching_length
    custentity_sk_upsized_inverter
    custentity_sk_utility_account_name
    custentity_sk_utility_account_number
    custentity_sk_xcel_premise_number
    custentity_skl_hs_dealid
    custentity_skl_hubspot_id
    custentity_ss_customer_class
    custentitysk_firstprojectcreated
    datecreated
    defaultbillingaddress
    defaultshippingaddress
    displaysymbol
    duplicate
    email
    emailpreference
    emailtransactions
    entityid
    entitynumber
    entitystatus
    entitytitle
    faxtransactions
    firstname
    firstorderdate
    firstsaledate
    giveaccess
    netsuite_customer_id
    isbudgetapproved
    isinactive
    isperson
    lastmodifieddate
    lastname
    lastorderdate
    lastsaledate
    leadsource
    links
    middlename
    mobilephone
    oncredithold
    overduebalancesearch
    overridecurrencyformat
    parent
    phone
    printoncheckas
    printtransactions
    probability
    receivablesaccount
    searchstage
    shipcomplete
    shippingcarrier
    startdate
    symbolplacement
    unbilledorderssearch
    weblead
    custentity_skl_sales_adders
    custentity_skl_sales_promises
    custentity_skl_hs_hoa_note
  )a

  schema "netsuite_customers" do
    field(:alcoholrecipienttype, :string)
    field(:altname, :string)
    field(:altphone, :string)
    field(:balancesearch, :string)
    field(:category, :string)
    field(:companyname, :string)
    field(:consolbalancesearch, :string)
    field(:consoldaysoverduesearch, :string)
    field(:consoloverduebalancesearch, :string)
    field(:consolunbilledorderssearch, :string)
    field(:creditholdoverride, :string)
    field(:currency, :string)
    field(:custentity2, :string)
    field(:custentity_bb_entity_latitude_text, :string)
    field(:custentity_bb_entity_longitude_text, :string)
    field(:custentity_bb_fin_install_per_watt_amt, :string)
    field(:custentity_bb_fin_orig_base_per_watt_amt, :string)
    field(:custentity_bb_fin_prelim_purch_price_amt, :string)
    field(:custentity_bb_financier_customer, :string)
    field(:custentity_bb_financier_payment_schedule, :string)
    field(:custentity_bb_financing_type, :string)
    field(:custentity_bb_home_owner_name_text, :string)
    field(:custentity_bb_home_owner_phone, :string)
    field(:custentity_bb_home_owner_primary_email, :string)
    field(:custentity_bb_homeowner_association, :string)
    field(:custentity_bb_install_address_1_text, :string)
    field(:custentity_bb_install_address_2_text, :string)
    field(:custentity_bb_install_city_text, :string)
    field(:custentity_bb_install_state, :string)
    field(:custentity_bb_install_zip_code_text, :string)
    field(:custentity_bb_inverter_quantity_num, :string)
    field(:custentity_bb_is_address_rec_boolean, :string)
    field(:custentity_bb_lead_start_date, :string)
    field(:custentity_bb_module_quantity_num, :string)
    field(:custentity_bb_ob_project_uuid, :string)
    field(:custentity_bb_project, :string)
    field(:custentity_sk_sales_rep, :string)
    field(:custentity_bb_spouse_name, :string)
    field(:custentity_bb_started_from_proj_template, :string)
    field(:custentity_bb_system_size_decimal, :string)
    field(:custentity_bb_utility_company, :string)
    field(:custentity_bb_warehouse_location, :string)
    field(:custentity_bbss_configuration, :string)
    field(:custentity_bluchat_full_mention_list, :string)
    field(:custentity_sk_array_type, :string)
    field(:custentity_sk_battery_model, :string)
    field(:custentity_sk_cash_back, :string)
    field(:custentity_sk_closing_customer_notes, :string)
    field(:custentity_sk_critter_guard, :string)
    field(:custentity_sk_derate_breaker, :string)
    field(:custentity_sk_ev_charger, :string)
    field(:custentity_sk_extended_invertery_warrant, :string)
    field(:custentity_sk_extended_product, :string)
    field(:custentity_sk_finance_term_length, :string)
    field(:custentity_sk_hoi_received, :string)
    field(:custentity_sk_interest_rate, :string)
    field(:custentity_sk_inverter_model, :string)
    field(:custentity_sk_led, :string)
    field(:custentity_sk_main_panel_upgrade, :string)
    field(:custentity_sk_meter_combine, :string)
    field(:custentity_sk_meter_upgrade, :string)
    field(:custentity_sk_module_model, :string)
    field(:custentity_sk_module_size, :string)
    field(:custentity_sk_number_of_arrays, :string)
    field(:custentity_sk_panel_skirts, :string)
    field(:custentity_sk_premium_panels, :string)
    field(:custentity_sk_proposal_link, :string)
    field(:custentity_sk_roof_pitch, :string)
    field(:custentity_sk_roof_reinforcement, :string)
    field(:custentity_sk_roof_repairs, :string)
    field(:custentity_sk_site_survey_date, :string)
    field(:custentity_sk_smart_thermostat, :string)
    field(:custentity_sk_tree_trimming, :string)
    field(:custentity_sk_trenching_ground_type, :string)
    field(:custentity_sk_trenching_length, :string)
    field(:custentity_sk_upsized_inverter, :string)
    field(:custentity_sk_utility_account_name, :string)
    field(:custentity_sk_utility_account_number, :string)
    field(:custentity_sk_xcel_premise_number, :string)
    field(:custentity_skl_hs_dealid, :integer)
    field(:custentity_skl_hubspot_id, :integer)
    field(:custentity_ss_customer_class, :string)
    field(:custentitysk_firstprojectcreated, :string)
    field(:datecreated, :string)
    field(:defaultbillingaddress, :string)
    field(:defaultshippingaddress, :string)
    field(:displaysymbol, :string)
    field(:duplicate, :string)
    field(:email, :string)
    field(:emailpreference, :string)
    field(:emailtransactions, :string)
    field(:entityid, :string)
    field(:entitynumber, :string)
    field(:entitystatus, :string)
    field(:entitytitle, :string)
    field(:faxtransactions, :string)
    field(:firstname, :string)
    field(:firstorderdate, :string)
    field(:firstsaledate, :string)
    field(:giveaccess, :string)
    field(:netsuite_customer_id, :integer)
    field(:isbudgetapproved, :string)
    field(:isinactive, :string)
    field(:isperson, :string)
    field(:lastmodifieddate, :string)
    field(:lastname, :string)
    field(:lastorderdate, :string)
    field(:lastsaledate, :string)
    field(:leadsource, :string)
    field(:links, {:array, :string})
    field(:middlename, :string)
    field(:mobilephone, :string)
    field(:oncredithold, :string)
    field(:overduebalancesearch, :string)
    field(:overridecurrencyformat, :string)
    field(:parent, :string)
    field(:phone, :string)
    field(:printoncheckas, :string)
    field(:printtransactions, :string)
    field(:probability, :string)
    field(:receivablesaccount, :string)
    field(:searchstage, :string)
    field(:shipcomplete, :string)
    field(:shippingcarrier, :string)
    field(:startdate, :string)
    field(:symbolplacement, :string)
    field(:unbilledorderssearch, :string)
    field(:weblead, :string)
    field(:custentity_skl_sales_adders, :string)
    field(:custentity_skl_sales_promises, :string)
    field(:custentity_skl_hs_hoa_note, :string)

    timestamps()
  end

  def new(%{}) do
    %__MODULE__{}
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:netsuite_customer_id])
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_customer_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_customer_id)
  end

  def read() do
    Repo.all(__MODULE__)
  end

  def read(query) do
    Repo.all(query)
  end

  def update(original, attrs) do
    original
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete(original) do
    original
    |> Repo.delete!()
  end
end
