defmodule Financesapp.Repo.Migrations.CreateSubcategories do
  use Ecto.Migration

  def change do
    create table(:subcategories) do
      add(:name, :string, null: false)
      add(:color, :string, null: false)
      add(:user_id, references(:users), null: false)
      add(:category_id, references(:categories), null: false)

      timestamps()
    end
  end
end
