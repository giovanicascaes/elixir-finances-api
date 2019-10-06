defmodule Financesapp.Business.Category do
  import Ecto.Query
  alias Financesapp.{Repo, Models.Category, Models.Subcategory, Models.Utils, Models.Transaction}

  def list_categories() do
    from(c in Category)
    |> Repo.all()
  end

  def list_subcategories(%{category_id: category_id}) do
    from(s in Subcategory, where: s.category_id == ^category_id)
    |> Repo.all()
  end

  def create_category(user, args) do
    create(user, args, &Category.changeset/1)
  end

  def create_subcategory(user, args) do
    create(user, args, &Subcategory.changeset/1)
  end

  defp create(user, args, changeset_fun) do
    args
    |> Map.put(:user_id, user.id)
    |> changeset_fun.()
    |> Repo.insert()
    |> case do
      {:error, changeset} ->
        {:error, Utils.Ecto.extract_changeset_errors(changeset)}

      other ->
        other
    end
  end

  def list_categories_with_balance(%{income: income, year: year, month: month}) do
    sql = """
    with
      filtered_transactions as (
        select
          *
        from
          transactions
        where
          date_trunc('MONTH', transactions.due_date) = $1::date
        and transactions.amount #{if income, do: "> 0", else: "< 0"}
      ),
      transactions_total as (
        select
          sum(filtered_transactions.amount) amount
        from
          filtered_transactions
      ),
      category_balance as (
        select
          categories.id,
          categories.name,
          categories.color,
          sum(filtered_transactions.amount) balance,
          round(cast((sum(filtered_transactions.amount) * 100) / transactions_total.amount as numeric), 2) percent
        from filtered_transactions
        join categories on filtered_transactions.category_id = categories.id, transactions_total
        group by
          categories.id,
          categories.name,
          categories.color,
          transactions_total.amount
    )
    select
      *
    from
      category_balance
    """

    month_as_date = %Date{year: year, month: month, day: 1}
    result = Repo.query!(sql, [month_as_date])
    cols = Enum.map(result.columns, &String.to_atom(&1))

    categories =
      Enum.map(result.rows, fn row ->
        struct(
          Financesapp.Structs.CategoryWithBalance,
          Enum.zip(cols, row)
        )
      end)

    categories_total =
      from(t in Transaction, select: sum(t.amount))
      |> where([q], fragment("date_trunc('month', ?)", q.due_date) == type(^month_as_date, :date))
      |> (fn query ->
            case income do
              true -> where(query, [q], q.amount > ^0)
              false -> where(query, [q], q.amount < ^0)
            end
          end).()
      |> Repo.one()

    %{
      balance: categories_total,
      categories: categories
    }
  end

  def list_subcategories_with_balance(%{
        category_id: category_id,
        income: income,
        year: year,
        month: month
      }) do
    sql = """
    with
      filtered_transactions as (
        select
          *
        from
          transactions
        where
          date_trunc('MONTH', transactions.due_date) = $1::date
        and transactions.amount #{if income, do: "> 0", else: "< 0"}
      ),
      transactions_total as (
        select
          sum(filtered_transactions.amount) amount
        from
          filtered_transactions
      ),
      subcategory_balance as (
        select
          subcategories.id,
          subcategories.name,
          subcategories.color,
          sum(filtered_transactions.amount) balance,
          round(cast((sum(filtered_transactions.amount) * 100) / transactions_total.amount as numeric), 2) percent
        from filtered_transactions
        join subcategories on filtered_transactions.subcategory_id = subcategories.id, transactions_total
        where subcategories.category_id = #{category_id}
        group by
          subcategories.id,
          subcategories.name,
          subcategories.color,
          transactions_total.amount
    )
    select
      *
    from
      subcategory_balance
    """

    month_as_date = %Date{year: year, month: month, day: 1}
    result = Repo.query!(sql, [month_as_date])
    cols = Enum.map(result.columns, &String.to_atom(&1))

    subcategories =
      Enum.map(result.rows, fn row ->
        struct(
          Financesapp.Structs.CategoryWithBalance,
          Enum.zip(cols, row)
        )
      end)

    subcategories_total =
      from(t in Transaction, select: sum(t.amount))
      |> where([q], fragment("date_trunc('month', ?)", q.due_date) == type(^month_as_date, :date))
      |> where([q], q.category_id == ^category_id)
      |> (fn query ->
            case income do
              true -> where(query, [q], q.amount > ^0)
              false -> where(query, [q], q.amount < ^0)
            end
          end).()
      |> Repo.one()

    %{
      balance: subcategories_total,
      subcategories: subcategories
    }
  end
end
