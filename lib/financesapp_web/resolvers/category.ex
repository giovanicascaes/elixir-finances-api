defmodule FinancesappWeb.Resolvers.Category do
  alias Financesapp.Business.Category

  def list_categories(_parent, _args, _resolution) do
    {:ok, Category.list_categories()}
  end

  def list_subcategories(_parent, args, _resolution) do
    {:ok, Category.list_subcategories(args)}
  end

  def create_category(_parent, args, %{context: %{current_user: user}}) do
    Category.create_category(user, args)
  end

  def create_category(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def create_subcategory(_parent, args, %{context: %{current_user: user}}) do
    Category.create_subcategory(user, args)
  end

  def create_subcategory(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def list_categories_with_balance(_parent, args, _resolution) do
    {:ok, Category.list_categories_with_balance(args)}
  end

  def list_subcategories_with_balance(_parent, args, _resolution) do
    {:ok, Category.list_subcategories_with_balance(args)}
  end
end
