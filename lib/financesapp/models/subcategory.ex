defmodule Financesapp.Models.Subcategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Financesapp.Models.{User, Category}

  schema "subcategories" do
    field :name, :string
    field :color, :string
    belongs_to :user, User
    belongs_to :category, Category

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @required_fields [:name, :color, :user_id, :category_id]
  def changeset(%__MODULE__{} = subcategory, params) do
    subcategory
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
