defmodule Financesapp.Models.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Financesapp.Models.{User, Subcategory}

  schema "categories" do
    field :name, :string
    field :color, :string
    belongs_to :user, User
    has_many :subcategories, Subcategory

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @required_fields [:name, :color, :user_id]
  def changeset(%__MODULE__{} = category, params) do
    category
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
