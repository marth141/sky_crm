defmodule SkylineEmployeeManager.SkylineEmployee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skyline_employees" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:department, :string)
    has_many(:equipment, SkylineEmployeeManager.SkylineItEquipment, on_replace: :nilify)
  end

  def changeset(skyline_employee, params \\ %{}) do
    skyline_employee
    |> cast(params, [:first_name, :last_name, :email, :department])
    |> validate_required([:first_name, :last_name, :email, :department])
  end

  def add_equipment_changeset(skyline_employee, equipment, params \\ %{}) do
    skyline_employee =
      skyline_employee
      |> Repo.preload(:equipment)

    skyline_employee
    |> cast(params, [:first_name, :last_name, :email, :department])
    |> validate_required([:first_name, :last_name, :email, :department])
    |> put_assoc(
      :equipment,
      [equipment | skyline_employee.equipment] |> List.flatten()
    )
  end

  def update_equipment_changeset(skyline_employee, equipment, params \\ %{}) do
    skyline_employee
    |> cast(params, [:first_name, :last_name, :email, :department])
    |> validate_required([:first_name, :last_name, :email, :department])
    |> put_assoc(:equipment, equipment)
  end

  def remove_equipment_changeset(skyline_employee, params \\ %{}) do
    skyline_employee
    |> cast(params, [:first_name, :last_name, :email, :department])
    |> validate_required([:first_name, :last_name, :email, :department])
    |> put_assoc(:equipment, [])
  end

  def update_user(user, equipment, params) do
    user
    |> update_equipment_changeset(equipment, params)
    |> Repo.update()
  end

  def create_user(params \\ %{}) do
    %SkylineEmployeeManager.SkylineEmployee{}
    |> changeset(params)
    |> Repo.insert()
  end

  defp example() do
    %GoogleApi.Admin.Directory_v1.Model.User{
      password: nil,
      emails: [
        %{"address" => "@org", "primary" => true},
        %{"address" => "@org.test-google-a.com"}
      ],
      notes: nil,
      kind: "admin#directory#user",
      sshPublicKeys: nil,
      id: "105989739993926154319",
      recoveryEmail: "payroll@org",
      locations: nil,
      nonEditableAliases: ["@org.test-google-a.com"],
      customerId: "C036cqdk8",
      name: %GoogleApi.Admin.Directory_v1.Model.UserName{
        familyName: "Payable",
        fullName: "Accounts Payable",
        givenName: "Accounts"
      },
      isAdmin: false,
      ims: nil,
      deletionTime: nil,
      hashFunction: nil,
      externalIds: nil,
      languages: [%{"languageCode" => "en", "preference" => "preferred"}],
      changePasswordAtNextLogin: false,
      aliases: nil,
      isMailboxSetup: true,
      lastLoginTime: ~U[2022-06-11 19:11:20.000Z],
      websites: nil,
      orgUnitPath: "/Accounting/Robots",
      thumbnailPhotoUrl: nil,
      recoveryPhone: "+14354069963",
      isDelegatedAdmin: false,
      etag: "\"BaflumSldTkzoWTAlyoWtlN_5YFcmUWLHa5J6q1mQVs/TNs_4ZdN0MhmfVSBDQQcynxIPaU\"",
      isEnforcedIn2Sv: false,
      customSchemas: nil,
      posixAccounts: nil,
      relations: nil,
      thumbnailPhotoEtag: nil,
      phones: nil,
      organizations: nil,
      keywords: nil,
      primaryEmail: "accounts.payable@org",
      suspensionReason: nil,
      includeInGlobalAddressList: true,
      agreedToTerms: true,
      suspended: false,
      creationTime: ~U[2018-07-26 16:48:23.000Z],
      gender: nil,
      archived: false,
      addresses: nil,
      isEnrolledIn2Sv: false,
      ipWhitelisted: false
    }
  end
end
