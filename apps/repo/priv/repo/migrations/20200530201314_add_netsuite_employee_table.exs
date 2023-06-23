defmodule Repo.Migrations.AddNetsuiteEmployeeTable do
  use Ecto.Migration

  def up do
    create table("netsuite_employees") do
      add :class, :text
      add :comments, :text
      add :custentity_bb_is_project_manager, :text
      add :custentity_bb_solar_success_access, :text
      add :custentity_bluchat_full_mention_list, :text
      add :datecreated, :text
      add :defaultjobresourcerole, :text
      add :department, :text
      add :email, :text
      add :entityid, :text
      add :firstname, :text
      add :gender, :text
      add :giveaccess, :text
      add :hiredate, :text
      add :i9verified, :text
      add :netsuite_employee_id, :bigint
      add :initials, :text
      add :isinactive, :text
      add :isjobmanager, :text
      add :isjobresource, :text
      add :issalesrep, :text
      add :issupportrep, :text
      add :lastmodifieddate, :text
      add :lastname, :text
      add :links, {:array, :text}
      add :mobilephone, :text
      add :phone, :text
      add :purchaseorderlimit, :text
      add :rolesforsearch, :text
      add :subsidiary, :text
      add :supervisor, :text
      add :targetutilization, :text
      add :title, :text
      add :workcalendar, :text
      timestamps()
    end

    create unique_index(:netsuite_employees, [:netsuite_employee_id])
  end

  def down do
    drop table("netsuite_employees")
  end
end
