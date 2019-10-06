defmodule Financesapp.Business.Account do
  alias Financesapp.{Repo, Models.Account, Models.Utils}

  def list_accounts() do
    sql = """
    WITH current_amount AS ( SELECT account_id, SUM ( amount ) amount FROM transactions WHERE due_date <= CURRENT_DATE GROUP BY account_id ),
    foreseen_amount AS (
      SELECT
        account_id,
        SUM ( amount ) amount
      FROM
        transactions
      WHERE
        due_date > CURRENT_DATE
        AND due_date <= ( date_trunc( 'MONTH', CURRENT_DATE ) + INTERVAL '1 MONTH - 1 day' ) :: DATE
      GROUP BY
        account_id
      ) SELECT ID
      ,
      NAME,
      initial_amount + COALESCE(current_amount.amount, 0) balance,
      initial_amount + COALESCE(current_amount.amount, 0) + COALESCE(foreseen_amount.amount, 0) foreseen_balance
    FROM
      accounts
      LEFT JOIN current_amount ON accounts.ID = current_amount.account_id
      LEFT JOIN foreseen_amount ON accounts.ID = foreseen_amount.account_id
    """

    result = Repo.query!(sql)
    cols = Enum.map(result.columns, &String.to_atom(&1))

    Enum.map(result.rows, fn row ->
      struct(
        Financesapp.Structs.Account,
        Enum.zip(cols, row)
      )
    end)
  end

  def create_account(user, args) do
    args
    |> Map.put(:user_id, user.id)
    |> Account.changeset()
    |> Repo.insert()
    |> case do
      {:error, changeset} ->
        {:error, Utils.Ecto.extract_changeset_errors(changeset)}

      other ->
        other
    end
  end
end
