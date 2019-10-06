defmodule FinancesappWeb.Resolvers.Account do
  alias Financesapp.Business.Account

  def list_accounts(_parent, _args, _resolution) do
    {:ok, Account.list_accounts()}
  end

  def create_account(_parent, args, %{context: %{current_user: user}}) do
    Account.create_account(user, args)
  end

  def create_account(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
