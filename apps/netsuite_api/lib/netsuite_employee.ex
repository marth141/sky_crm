defmodule NetsuiteApi.Employee do
  @doc """
  This is used to describe a Netsuite Employee with Ecto Schemas
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(
    class
    comments
    custentity_bb_is_project_manager
    custentity_bb_solar_success_access
    custentity_bluchat_full_mention_list
    datecreated
    defaultjobresourcerole
    department
    email
    entityid
    firstname
    gender
    giveaccess
    hiredate
    i9verified
    netsuite_employee_id
    initials
    isinactive
    isjobmanager
    isjobresource
    issalesrep
    issupportrep
    lastmodifieddate
    lastname
    links
    mobilephone
    phone
    purchaseorderlimit
    rolesforsearch
    subsidiary
    supervisor
    targetutilization
    title
    workcalendar
  )a

  schema "netsuite_employees" do
    field(:class, :string)
    field(:comments, :string)
    field(:custentity_bb_is_project_manager, :string)
    field(:custentity_bb_solar_success_access, :string)
    field(:custentity_bluchat_full_mention_list, :string)
    field(:datecreated, :string)
    field(:defaultjobresourcerole, :string)
    field(:department, :string)
    field(:email, :string)
    field(:entityid, :string)
    field(:firstname, :string)
    field(:gender, :string)
    field(:giveaccess, :string)
    field(:hiredate, :string)
    field(:i9verified, :string)
    field(:netsuite_employee_id, :integer)
    field(:initials, :string)
    field(:isinactive, :string)
    field(:isjobmanager, :string)
    field(:isjobresource, :string)
    field(:issalesrep, :string)
    field(:issupportrep, :string)
    field(:lastmodifieddate, :string)
    field(:lastname, :string)
    field(:links, {:array, :string})
    field(:mobilephone, :string)
    field(:phone, :string)
    field(:purchaseorderlimit, :string)
    field(:rolesforsearch, :string)
    field(:subsidiary, :string)
    field(:supervisor, :string)
    field(:targetutilization, :string)
    field(:title, :string)
    field(:workcalendar, :string)

    timestamps()
  end

  def new(%{}) do
    %__MODULE__{}
  end

  def changeset(original, attrs \\ %{}) do
    original
    |> cast(attrs, @fields)
    |> unique_constraint([:netsuite_employee_id])
  end

  def create(%Ecto.Changeset{valid?: true} = attrs) do
    attrs
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_employee_id)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!(on_conflict: :replace_all, conflict_target: :netsuite_employee_id)
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
