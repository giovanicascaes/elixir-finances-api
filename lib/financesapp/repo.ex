defmodule Financesapp.Repo do
  use Ecto.Repo,
    otp_app: :financesapp,
    adapter: Ecto.Adapters.Postgres
end
