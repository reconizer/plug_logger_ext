defmodule PlugLoggerExt.MetaTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import ExUnit.CaptureLog
  require Logger

  setup do
    conn = conn(:get, "/")

    Logger.configure_backend(:console, metadata: [:app, :id])
    on_exit(fn -> Logger.configure_backend(:console, metadata: []) end)

    [conn: conn]
  end

  test "lets you add meta fields to Logger", context do
    assert capture_log(fn ->
             context.conn |> PlugLoggerExt.Meta.call(app: "TEST")
             Logger.info("TEST")
           end) =~ "app=TEST"

    assert capture_log(fn ->
             context.conn |> PlugLoggerExt.Meta.call(id: 1234)
             Logger.info("TEST")
           end) =~ "id=1234"
  end
end
