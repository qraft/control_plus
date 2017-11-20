defmodule ControlPlus.Helpers.TimeHelperTest do
  use ExUnit.Case, async: false

  test "it can format a time" do
    formatted_time = ControlPlus.Helpers.TimeHelper.format_time(Time.utc_now())
    assert Regex.match?(~r/^\d+:\d+:\d+$/, formatted_time)
  end

  test "it can parse a time" do
    assert {:ok, ~T[23:59:59]} == ControlPlus.Helpers.TimeHelper.parse("23:59:59")
    assert ~T[23:59:59] == ControlPlus.Helpers.TimeHelper.parse!("23:59:59")
    assert ~T[01:01:01] == ControlPlus.Helpers.TimeHelper.parse!("01:01:01")
  end
end
