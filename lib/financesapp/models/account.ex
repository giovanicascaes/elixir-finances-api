defmodule Financesapp.Models.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Financesapp.Models.{User, Transaction}

  schema "accounts" do
    field :name, :string
    field :initial_amount, :float
    belongs_to :user, User
    has_many :transactions, Transaction

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(%__MODULE__{} = account, params) do
    account
    |> cast(params, [:name, :initial_amount, :user_id])
    |> validate_required([:name, :user_id])
  end
end
