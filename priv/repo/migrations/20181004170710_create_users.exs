defmodule Corker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :slack_id, :string, null: false

      timestamps()
    end

    create unique_index(:users, :slack_id)
  end
end
