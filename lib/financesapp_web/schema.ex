defmodule FinancesappWeb.Schema do
  use Absinthe.Schema
  import_types(FinancesappWeb.Schema.Types)

  alias FinancesappWeb.Resolvers

  query do
    @desc "Get all accounts"
    field :accounts, list_of(:account_balance) do
      resolve(&Resolvers.Account.list_accounts/3)
    end
´
    @desc "Get transactions"
    field :transactions, list_of(:transaction) do
      arg(:account_id, :integer)
      arg(:category_id, :integer)
      arg(:subcategory_id, :integer)
      arg(:year, :integer)
      arg(:month, :integer)
      arg(:done, :boolean)
      arg(:labels, list_of(:string))
      arg(:notes, :string)
      arg(:title, :string)

      resolve(&Resolvers.Transaction.list_transactions/3)
    end

    @desc "Get monthly statement"
    field :statement, list_of(:daily_statement) do
      arg(:year, non_null(:integer))
      arg(:month, non_null(:integer))

      resolve(&Resolvers.Transaction.get_statement/3)
    end

    @desc "Get categories"
    field :categories, list_of(:category) do
      resolve(&Resolvers.Category.list_categories/3)
    end

    @desc "Get subcategories"
    field :subcategories, list_of(:subcategory) do
      arg(:category_id, non_null(:integer))

      resolve(&Resolvers.Category.list_subcategories/3)
    end

    @desc "Get categories with balance"
    field :categories_with_balance, list_of(:categories_balance) do
      arg(:income, non_null(:boolean))
      arg(:year, non_null(:integer))
      arg(:month, non_null(:integer))

      resolve(&Resolvers.Category.list_categories_with_balance/3)
    end

    @desc "Get subcategories of a given category with balance"
    field :subcategories_with_balance, list_of(:subcategories_balance) do
      arg(:category_id, non_null(:integer))
      arg(:income, non_null(:boolean))
      arg(:year, non_null(:integer))
      arg(:month, non_null(:integer))

      resolve(&Resolvers.Category.list_subcategories_with_balance/3)
    end
  end

  mutation do
    @desc "Create an account"
    field :create_account, type: :account do
      arg(:name, non_null(:string))
      arg(:initial_amount, :float)

      resolve(&Resolvers.Account.create_account/3)
    end

    @desc "Create a transaction"
    field :create_transaction, type: :transaction do
      arg(:title, non_null(:string))
      arg(:amount, non_null(:float))
      arg(:due_date, non_null(:string))
      arg(:notes, :string)
      arg(:labels, list_of(:string))
      arg(:account_id, non_null(:integer))
      arg(:category_id, non_null(:integer))
      arg(:subcategory_id, non_null(:integer))

      resolve(&Resolvers.Transaction.create_transaction/3)
    end

    @desc "Create a category"
    field :create_category, type: :category do
      arg(:name, non_null(:string))
      arg(:color, non_null(:string))

      resolve(&Resolvers.Category.create_category/3)
    end

    @desc "Create a subcategory"
    field :create_subcategory, type: :subcategory do
      arg(:name, non_null(:string))
      arg(:color, non_null(:string))
      arg(:category_id, non_null(:integer))

      resolve(&Resolvers.Category.create_subcategory/3)
    end
  end
end
