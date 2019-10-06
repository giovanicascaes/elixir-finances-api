defmodule Financesapp.Business.Transaction do
  import Ecto.Query
  alias Financesapp.{Repo, Models.Transaction}
  require Financesapp.Models.Utils.Ecto

  def list_transactions(args) do
    from(t in Transaction, select: t, preload: [:account, :labels, :category, :subcategory])
    |> (fn query ->
          case args do
            %{category_id: category_id} ->
              where(query, [q], q.category_id == ^category_id)

            %{subcategory_id: subcategory_id} ->
              where(query, [q], q.subcategory_id == ^subcategory_id)

            %{year: year, month: month} ->
              month_as_date = %Date{year: year, month: month, day: 1}

              where(
                query,
                [q],
                fragment("date_trunc('month', ?)", q.due_date) == type(^month_as_date, :date)
              )

            %{title: title} ->
              where(query, [q], ilike(q.title, ^"%#{title}%"))

            %{account_id: account_id} ->
              where(query, [q], q.account_id == ^account_id)

            %{done: done} ->
              where(query, [q], q.done == ^done)

            %{labels: labels} ->
              join(query, :inner, [q], l in assoc(q, :labels))
              |> where([_, l], l.label in ^labels)

            %{notes: notes} ->
              where(query, [q], ilike(q.notes, ^"%#{notes}%"))

            _ ->
              query
          end
        end).()
    |> Repo.all()
  end

  def get_statement(%{year: year, month: month}) do
    month_as_date = %Date{year: year, month: month, day: 1}

    from(t in Transaction,
      where: fragment("date_trunc('month', ?)", t.due_date) == type(^month_as_date, :date),
      order_by: t.due_date,
      select: t,
      preload: [:labels, :category, :subcategory]
    )
    |> Repo.all()
    |> Enum.group_by(fn trx -> trx.due_date end)
    |> Enum.map_reduce(0, fn {k, v}, acc ->
      balance = acc + Enum.reduce(v, 0, fn trx, acc -> acc + trx.amount end)

      {%{
         date: k,
         transactions: v,
         balance: balance
       }, balance}
    end)
    |> elem(0)
  end

  def create_transaction(user, args) do
    args
    |> Map.put(:user_id, user.id)
    |> Transaction.changeset()
    |> Repo.insert()
    |> case do
      {:error, changeset} ->
        {:error, Financesapp.Models.Utils.Ecto.extract_changeset_errors(changeset)}

      other ->
        other
    end
  end
end
