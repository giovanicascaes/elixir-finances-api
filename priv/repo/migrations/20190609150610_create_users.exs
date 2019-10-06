defmodule Financesapp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string, null: false)
      add(:username, :string, null: false)
      add(:token, :string)

      timestamps()
    end
  end
end
