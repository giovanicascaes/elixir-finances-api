defmodule Financesapp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:title, :string, null: false)
      add(:amount, :float, null: false)
      add(:notes, :string)
      add(:due_date, :date, null: false)
      add(:user_id, references(:users), null: false)
      add(:account_id, references(:accounts), null: false)
      add(:category_id, references(:categories), null: false)
      add(:subcategory_id, references(:subcategories), null: false)
      add(:done, :boolean, null: false, default: false)

      timestamps()
    end
  end
end
