defmodule Financesapp.Models.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Financesapp.Models.{Account, Label, User, Category, Subcategory, TransactionLabel}
  alias Financesapp.Repo

  schema "transactions" do
    field :title, :string
    field :amount, :float
    field :due_date, :date
    field :notes, :string
    field :done, :boolean
    belongs_to :user, User
    belongs_to :account, Account
    many_to_many :labels, Label, join_through: TransactionLabel
    belongs_to :category, Category
    belongs_to :subcategory, Subcategory

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(%__MODULE__{} = transaction, params) do
    transaction
    |> cast(params, [
      :title,
      :amount,
      :notes,
      :done,
      :due_date,
      :account_id,
      :category_id,
      :subcategory_id,
      :user_id
    ])
    |> put_assoc(:labels, parse_labels(params))
    |> validate_required([
      :title,
      :amount,
      :done,
      :due_date,
      :account_id,
      :category_id,
      :subcategory_id,
      :user_id
    ])
    |> validate_number(:amount, not_equal_to: 0)
  end

  defp parse_labels(params) do
    params.labels
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&get_or_insert_label(%{label: &1, user_id: params.user_id}))
  end

  defp get_or_insert_label(params) do
    Repo.get_by(Label, label: params.label) ||
      Repo.insert!(struct(Label, params))
  end
end
