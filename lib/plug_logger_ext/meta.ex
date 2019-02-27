defmodule PlugLoggerExt.Meta do
  require Logger

  def init(arg), do: arg

  def call(conn, meta) do
    Logger.metadata(meta)

    conn
  end
end
