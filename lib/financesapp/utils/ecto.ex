defmodule Financesapp.Models.Utils.Ecto do
  def extract_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.flat_map(fn {field, messages} ->
      Enum.map(messages, fn m ->
        %{
          field: Absinthe.Utils.camelize(to_string(field), lower: true),
          message: m
        }
      end)
    end)
  end
end
