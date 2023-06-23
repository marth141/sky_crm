defmodule Repo.Migrations.AddNetsuiteCaseTable do
  use Ecto.Migration

  def up do
    create table("netsuite_cases") do
      add(:title, :string)
      add(:priority, :string)
      add(:incomingMessage, :string)
      add(:startDate, :string)
      add(:status, :string)
      add(:subsidiary, :string)
      add(:phone, :string)
      add(:company, :bigint)
      add(:customForm, :string)
      add(:email, :string)
      add(:assigned, :string)
      add(:profile, :string)
      add(:custevent_skl_related_hubspot_contactid, :bigint)
      add(:custevent_skl_related_hubspot_ticket_id, :bigint)
      add(:custevent_skl_related_hubspot_deal_id, :bigint)
      add(:netsuite_case_id, :bigint)
      add(:quickNote, :string)
    end

    create unique_index(:netsuite_cases, [:netsuite_case_id])
  end

  def down do
    drop table("netsuite_cases")
  end
end
