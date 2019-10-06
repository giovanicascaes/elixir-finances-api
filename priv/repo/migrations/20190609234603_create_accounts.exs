defmodule Financesapp.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:name, :string, null: false)
      add(:initial_amount, :float, default: 0)
      add(:user_id, references(:users), null: false)

      timestamps()
    end
  end
end
