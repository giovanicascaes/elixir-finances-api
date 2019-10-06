defmodule Financesapp.Business.User do
  import Ecto.Query, only: [where: 2]

  alias Financesapp.{Repo, Models.User}

  def get_user_by_token(token) do
    User
    |> where(token: ^token)
    |> Repo.one()
    |> case do
      nil -> {:error, "invalid authorization token"}
      user -> {:ok, user}
    end
  end
end
