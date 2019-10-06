defmodule Financesapp.Repo.Migrations.CreateTransactionsLabels do
  use Ecto.Migration

  def change do
    create table(:transactions_labels) do
      add(:transaction_id, references(:transactions), null: false)
      add(:label_id, references(:labels), null: false)

      timestamps()
    end
  end
end
