defmodule Repo.Migrations.AddNetsuiteAuthorityHandlingJurisdictionTable do
  use Ecto.Migration

  def up do
    create table("netsuite_authority_handling_jurisdictions") do
      add(:created, :string)
      add(:custrecord159, :string)
      add(:custrecord_bb_ahj_state_province_state, :string)
      add(:netsuite_authority_handling_jurisdiction_id, :string)
      add(:isinactive, :string)
      add(:lastmodified, :string)
      add(:links, {:array, :string})
      add(:name, :string)
      add(:owner, :string)
      add(:recordid, :string)
      add(:scriptid, :string)
      add(:custrecord_bb_ahj_doc_sub_method_text, :string)
      add(:custrecord_bb_ahj_bldg_code_notes_text, :string)
      add(:custrecord_bb_ahj_elec_code_notes_text, :string)
      add(:custrecord_bb_ahj_description_text, :string)
      add(:custrecord_bb_ahj_address, :string)
      add(:custrecord_bb_ahj_code_uuid, :string)
      add(:custrecord_bb_ahj_county_text, :string)
      add(:custrecord_bb_ahj_phone, :string)
      add(:custrecord_bb_ahj_address_line1_text, :string)
      add(:custrecord_bb_ahj_building_code_text, :string)
      add(:custrecord_bb_ahj_city_text, :string)
      add(:custrecord_bb_ahj_country_text, :string)
      add(:custrecord_bb_ahj_electric_code_text, :string)
      add(:custrecord_bb_ahj_email, :string)
      add(:custrecord_bb_ahj_fire_code_text, :string)
      add(:custrecord_bb_ahj_postal_code_text, :string)
      add(:custrecord_bb_ahj_residential_code_text, :string)
      add(:custrecord_bb_ahj_contact, :string)
    end

    create unique_index(:netsuite_authority_handling_jurisdictions, [
             :netsuite_authority_handling_jurisdiction_id
           ])
  end

  def down do
    drop table("netsuite_authority_handling_jurisdictions")
  end
end
