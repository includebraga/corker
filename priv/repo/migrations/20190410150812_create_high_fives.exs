defmodule Corker.Repo.Migrations.CreateHighFives do
  use Ecto.Migration

  def change do
    create table(:high_fives) do
      add :sender_id, references(:users), null: false
      add :receiver_id, references(:users), null: false
      add :reason, :string, null: false

      timestamps()
    end
  end
end
