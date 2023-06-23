defmodule Repo.Migrations.AddUsersIsActiveBoolean do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_active, :boolean, default: true
    end
  end
end
