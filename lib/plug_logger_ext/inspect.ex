defmodule PlugLoggerExt.Inspect do
  require Logger

  def init(arg), do: arg

  def call(conn, meta) do
    meta
    |> Enum.each(fn {name, keys} ->
      data =
        keys
        |> Enum.reduce(conn, fn key, result ->
          result
          |> case do
            result = %{__struct__: _} ->
              result |> Map.from_struct() |> get_in([key])

            result when is_map(result) ->
              result |> get_in([key])

            result when is_list(result) and is_integer(key) ->
              result |> Enum.at(key)

            other ->
              other
          end
        end)

      Logger.info("#{name}: #{inspect(data)}")
    end)

    conn
  end
end
