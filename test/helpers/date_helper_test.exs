defmodule ControlPlus.Helpers.DateHelperTest do
  use ExUnit.Case, async: false

  test "it can format a date" do
    formatted_date = ControlPlus.Helpers.DateHelper.format_date(Timex.now)
    assert Regex.match?(~r/^\d+-\d+-\d+$/, formatted_date)
  end

  test "it can format a future date" do
    formatted_date = ControlPlus.Helpers.DateHelper.format_date_days_from_now(7)
    assert Regex.match?(~r/^\d+-\d+-\d+$/, formatted_date)
  end

  test "it can format a date in the past" do
    formatted_date = ControlPlus.Helpers.DateHelper.format_date_days_ago(7)
    assert Regex.match?(~r/^\d+-\d+-\d+$/, formatted_date)
  end

  test "it can parse a date" do
    assert {:ok, ~D[2017-06-05]} == ControlPlus.Helpers.DateHelper.parse("05/06/2017")
    assert ~D[2017-06-05] == ControlPlus.Helpers.DateHelper.parse!("05/06/2017")
  end

  test "it can format a date and time" do
    date_time = DateTime.from_naive!(~N[2017-11-01 13:01:08.000], "Etc/UTC")
    assert "01/11/2017 13:01:08" == ControlPlus.Helpers.DateHelper.format_date_time(date_time)
  end
end
