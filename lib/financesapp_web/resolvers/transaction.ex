defmodule FinancesappWeb.Resolvers.Transaction do
  alias Financesapp.Business.Transaction

  def list_transactions(_parent, args, _resolution) do
    {:ok, Transaction.list_transactions(args)}
  end

  def get_statement(_parent, args, _resolution) do
    {:ok, Transaction.get_statement(args)}
  end

  def create_transaction(_parent, args, %{context: %{current_user: user}}) do
    Transaction.create_transaction(user, args)
  end

  def create_transaction(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
