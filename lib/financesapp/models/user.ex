defmodule Financesapp.Models.User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :username, :string
    field :token, :string

    timestamps()
  end
end
