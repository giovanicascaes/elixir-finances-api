defmodule Financesapp.Models.TransactionLabel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Financesapp.Models.{Transaction, Label}

  schema "transactions_labels" do
    belongs_to :transaction, Transaction
    belongs_to :label, Label

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = transaction_label, params) do
    transaction_label
    |> cast(params, [])
    |> validate_required([])
  end
end
