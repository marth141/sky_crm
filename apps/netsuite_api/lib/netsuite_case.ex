defmodule NetsuiteApi.Case do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    title
    priority
    incomingMessage
    startDate
    status
    subsidiary
    phone
    company
    customForm
    email
    assigned
    profile
    custevent_skl_related_hubspot_contactid
    custevent_skl_related_hubspot_ticket_id
    custevent_skl_related_hubspot_deal_id
    netsuite_case_id
    quickNote
  )a

  schema "netsuite_cases" do
    field(:title, :string)
    field(:priority, :string)
    field(:incomingMessage, :string)
    field(:startDate, :string)
    field(:status, :string)
    field(:subsidiary, :string)
    field(:phone, :string)
    field(:company, :integer)
    field(:customForm, :string)
    field(:email, :string)
    field(:assigned, :string)
    field(:profile, :string)
    field(:custevent_skl_related_hubspot_contactid, :integer)
    field(:custevent_skl_related_hubspot_ticket_id, :integer)
    field(:custevent_skl_related_hubspot_deal_id, :integer)
    field(:netsuite_case_id, :integer)
    field(:quickNote, :string)
  end

  def changeset(module, attrs \\ %{}) do
    module
    |> cast(attrs, @fields)
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_case_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_case_id)
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
      title: changeset_changes[:title],
      priority: changeset_changes[:priority],
      incomingMessage: changeset_changes[:incomingMessage],
      startDate: changeset_changes[:startDate],
      status: changeset_changes[:status],
      subsidiary: changeset_changes[:subsidiary],
      phone: changeset_changes[:phone],
      company: changeset_changes[:company],
      customForm: changeset_changes[:customForm],
      email: changeset_changes[:email],
      assigned: changeset_changes[:assigned],
      profile: changeset_changes[:profile],
      custevent_skl_related_hubspot_contactid:
        changeset_changes[:custevent_skl_related_hubspot_contactid],
      custevent_skl_related_hubspot_ticket_id:
        changeset_changes[:custevent_skl_related_hubspot_ticket_id],
      custevent_skl_related_hubspot_deal_id:
        changeset_changes[:custevent_skl_related_hubspot_deal_id],
      netsuite_case_id: changeset_changes[:netsuite_case_id],
      quickNote: changeset_changes[:quickNote]
    }
  end
end
