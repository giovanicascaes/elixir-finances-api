defmodule FinancesappWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :account do
    field :id, :id
    field :name, :string
    field :initial_amount, :float
  end

  object :account_basic do
    field :id, :id
    field :name, :string
  end

  object :account_balance do
    field :id, :id
    field :name, :string
    field :balance, :float
    field :foreseen_balance, :float
  end

  object :label do
    field :id, :id
    field :label, :string
  end

  object :transaction do
    field :id, :id
    field :title, :string
    field :amount, :float
    field :due_date, :string
    field :notes, :string
    field :labels, list_of(:label)
    field :category, type: :category
    field :subcategory, type: :subcategory
    field :done, :boolean
    field :account, type: :account_basic
  end

  object :daily_statement do
    field :date, :string
    field :transactions, list_of(:transaction)
    field :balance, :float
  end

  object :subcategory do
    field :id, :id
    field :name, :string
    field :color, :string
  end

  object :category do
    field :id, :id
    field :name, :string
    field :color, :string
  end

  object :categories_balance do
    field :balance, :float
    field :categories, list_of(:category_balance)
  end

  object :subcategories_balance do
    field :balance, :float
    field :subcategories, list_of(:category_balance)
  end

  object :category_balance do
    field :id, :integer
    field :name, :string
    field :color, :string
    field :balance, :float
    field :percent, :float
  end
end
