defmodule Financesapp.Models.Label do
  use Ecto.Schema
  import Ecto.Changeset

  schema "labels" do
    field :label, :string
    belongs_to :user, Financesapp.Models.User

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @required_fields [:label, :user_id]
  def changeset(%__MODULE__{} = label, params) do
    label
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
