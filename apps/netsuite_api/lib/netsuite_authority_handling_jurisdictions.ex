defmodule NetsuiteApi.AuthorityHandlingJurisdiction do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    created
    custrecord159
    custrecord_bb_ahj_state_province_state
    netsuite_authority_handling_jurisdiction_id
    isinactive
    lastmodified
    links
    name
    owner
    recordid
    scriptid
    custrecord_bb_ahj_doc_sub_method_text
    custrecord_bb_ahj_bldg_code_notes_text
    custrecord_bb_ahj_elec_code_notes_text
    custrecord_bb_ahj_description_text
    custrecord_bb_ahj_address
    custrecord_bb_ahj_code_uuid
    custrecord_bb_ahj_county_text
    custrecord_bb_ahj_phone
    custrecord_bb_ahj_address_line1_text
    custrecord_bb_ahj_building_code_text
    custrecord_bb_ahj_city_text
    custrecord_bb_ahj_country_text
    custrecord_bb_ahj_electric_code_text
    custrecord_bb_ahj_email
    custrecord_bb_ahj_fire_code_text
    custrecord_bb_ahj_postal_code_text
    custrecord_bb_ahj_residential_code_text
    custrecord_bb_ahj_contact
  )a

  schema "netsuite_authority_handling_jurisdictions" do
    field(:created, :string)
    field(:custrecord159, :string)
    field(:custrecord_bb_ahj_state_province_state, :string)
    field(:netsuite_authority_handling_jurisdiction_id, :string)
    field(:isinactive, :string)
    field(:lastmodified, :string)
    field(:links, {:array, :string})
    field(:name, :string)
    field(:owner, :string)
    field(:recordid, :string)
    field(:scriptid, :string)
    field(:custrecord_bb_ahj_doc_sub_method_text, :string)
    field(:custrecord_bb_ahj_bldg_code_notes_text, :string)
    field(:custrecord_bb_ahj_elec_code_notes_text, :string)
    field(:custrecord_bb_ahj_description_text, :string)
    field(:custrecord_bb_ahj_address, :string)
    field(:custrecord_bb_ahj_code_uuid, :string)
    field(:custrecord_bb_ahj_county_text, :string)
    field(:custrecord_bb_ahj_phone, :string)
    field(:custrecord_bb_ahj_address_line1_text, :string)
    field(:custrecord_bb_ahj_building_code_text, :string)
    field(:custrecord_bb_ahj_city_text, :string)
    field(:custrecord_bb_ahj_country_text, :string)
    field(:custrecord_bb_ahj_electric_code_text, :string)
    field(:custrecord_bb_ahj_email, :string)
    field(:custrecord_bb_ahj_fire_code_text, :string)
    field(:custrecord_bb_ahj_postal_code_text, :string)
    field(:custrecord_bb_ahj_residential_code_text, :string)
    field(:custrecord_bb_ahj_contact, :string)
  end

  def changeset(module, attrs \\ %{}) do
    module
    |> cast(attrs, @fields)
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(
      on_conflict: :replace_all,
      conflict_target: :netsuite_authority_handling_jurisdiction_id
    )
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(
      on_conflict: :replace_all,
      conflict_target: :netsuite_authority_handling_jurisdiction_id
    )
  end

  def create_embedded(attrs) do
    with %Ecto.Changeset{valid?: true} = cs <-
           %__MODULE__{} |> changeset(attrs) do
      {:ok,
       cs.changes
       |> new()}
    end
  end

  def create_embedded!(attrs) do
    with %Ecto.Changeset{valid?: true} = cs <-
           %__MODULE__{} |> changeset(attrs) do
      cs.changes
      |> new()
    end
  end

  def update(original, attrs) do
    original
    |> changeset(attrs)
    |> Repo.update()
  end

  defp new(changeset_changes) do
    %__MODULE__{
      created: changeset_changes[:created],
      custrecord159: changeset_changes[:custrecord159],
      custrecord_bb_ahj_state_province_state:
        changeset_changes[:custrecord_bb_ahj_state_province_state],
      netsuite_authority_handling_jurisdiction_id:
        changeset_changes[:netsuite_authority_handling_jurisdiction_id],
      isinactive: changeset_changes[:isinactive],
      lastmodified: changeset_changes[:lastmodified],
      links: changeset_changes[:links],
      name: changeset_changes[:name],
      owner: changeset_changes[:owner],
      recordid: changeset_changes[:recordid],
      scriptid: changeset_changes[:scriptid],
      custrecord_bb_ahj_doc_sub_method_text:
        changeset_changes[:custrecord_bb_ahj_doc_sub_method_text],
      custrecord_bb_ahj_bldg_code_notes_text:
        changeset_changes[:custrecord_bb_ahj_bldg_code_notes_text],
      custrecord_bb_ahj_elec_code_notes_text:
        changeset_changes[:custrecord_bb_ahj_elec_code_notes_text],
      custrecord_bb_ahj_description_text: changeset_changes[:custrecord_bb_ahj_description_text],
      custrecord_bb_ahj_address: changeset_changes[:custrecord_bb_ahj_address],
      custrecord_bb_ahj_code_uuid: changeset_changes[:custrecord_bb_ahj_code_uuid],
      custrecord_bb_ahj_county_text: changeset_changes[:custrecord_bb_ahj_county_text],
      custrecord_bb_ahj_phone: changeset_changes[:custrecord_bb_ahj_phone],
      custrecord_bb_ahj_address_line1_text:
        changeset_changes[:custrecord_bb_ahj_address_line1_text],
      custrecord_bb_ahj_building_code_text:
        changeset_changes[:custrecord_bb_ahj_building_code_text],
      custrecord_bb_ahj_city_text: changeset_changes[:custrecord_bb_ahj_city_text],
      custrecord_bb_ahj_country_text: changeset_changes[:custrecord_bb_ahj_country_text],
      custrecord_bb_ahj_electric_code_text:
        changeset_changes[:custrecord_bb_ahj_electric_code_text],
      custrecord_bb_ahj_email: changeset_changes[:custrecord_bb_ahj_email],
      custrecord_bb_ahj_fire_code_text: changeset_changes[:custrecord_bb_ahj_fire_code_text],
      custrecord_bb_ahj_postal_code_text: changeset_changes[:custrecord_bb_ahj_postal_code_text],
      custrecord_bb_ahj_residential_code_text:
        changeset_changes[:custrecord_bb_ahj_residential_code_text],
      custrecord_bb_ahj_contact: changeset_changes[:custrecord_bb_ahj_contact]
    }
  end
end
