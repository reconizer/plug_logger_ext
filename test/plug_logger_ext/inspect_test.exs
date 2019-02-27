defmodule PlugLoggerExt.InspectTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import ExUnit.CaptureLog

  setup do
    conn =
      conn(:get, "/", %{"test" => "test", "foo" => [%{"id" => 1}, %{"id" => 2}], "bar" => [1]})

    [conn: conn]
  end

  test "lets you inspect connection and log it to Logger", context do
    assert capture_log(fn ->
             context.conn |> PlugLoggerExt.Inspect.call(params: [:params, "test"])
           end) =~ "params: \"test\""

    assert capture_log(fn ->
             context.conn
             |> PlugLoggerExt.Inspect.call(foo_array: [:params, "foo", 1, "id"])
           end) =~ "foo_array: 2"

    assert capture_log(fn ->
             context.conn
             |> PlugLoggerExt.Inspect.call(foo_array: [:params, "bar", 2])
           end) =~ "foo_array: nil"

    assert capture_log(fn ->
             context.conn |> PlugLoggerExt.Inspect.call(Parameters: [:params, "test"])
           end) =~ "Parameters: \"test\""
  end
end
