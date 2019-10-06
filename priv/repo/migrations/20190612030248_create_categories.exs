defmodule Financesapp.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:name, :string, null: false)
      add(:color, :string, null: false)
      add(:user_id, references(:users), null: false)

      timestamps()
    end
  end
end
