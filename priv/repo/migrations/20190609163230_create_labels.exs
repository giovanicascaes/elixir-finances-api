defmodule Financesapp.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels) do
      add(:label, :string, null: false)
      add(:user_id, references(:users), null: false)

      timestamps()
    end

    create(unique_index(:labels, [:label]))
  end
end
