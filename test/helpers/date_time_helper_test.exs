defmodule ControlPlus.Helpers.DateTimeHelperTest do
  use ExUnit.Case

  test "it can convert naive datetime (europe/amsterdam) to UTC" do
    {:ok, utc} = ControlPlus.Helpers.DateTimeHelper.naive_to_utc(~N[2017-11-23 19:00:00.000])
    assert 18 == utc.hour

    banged_utc = ControlPlus.Helpers.DateTimeHelper.naive_to_utc!(~N[2017-11-23 19:00:00.000])
    assert 18 == banged_utc.hour


    {:ok, date_time} = ControlPlus.Helpers.DateTimeHelper.naive_to_utc(~D[2017-11-23], ~T[19:00:00.000])
    assert 18 == date_time.hour

    banged_date_time = ControlPlus.Helpers.DateTimeHelper.naive_to_utc!(~D[2017-11-23], ~T[19:00:00.000])
    assert 18 == banged_date_time.hour
  end

  test "it can format date times" do
    datetime = DateTime.from_naive!(~N[2017-11-23 19:00:00.000], "Etc/UTC")

    assert "23/11/2017 19:00:00" == ControlPlus.Helpers.DateTimeHelper.format_date_time_for_api(datetime)
    assert "23/11/2017 19:00:00" == ControlPlus.Helpers.DateTimeHelper.format_date_time(datetime)
    assert "2017/11/23 19:00:00" == ControlPlus.Helpers.DateTimeHelper.format_date_time_for_api(datetime, :reversed)
  end

  test "it can compose date and time" do
    assert %{
             ends_at: %DateTime{},
             foo: "bar",
             starts_at: %DateTime{}
           } = ControlPlus.Helpers.DateTimeHelper.compose_timestamps(
             %{foo: "bar"},
             %{date: ~D[2017-12-05], start_time: ~T[16:00:00], end_time: ~T[17:30:00]}
           )

    assert %{foo: "bar", starts_at: %DateTime{}} = ControlPlus.Helpers.DateTimeHelper.compose_timestamps(
             %{foo: "bar"},
             %{date: ~D[2017-12-05], start_time: ~T[16:00:00]}
           )

    assert %{foo: "bar"} == ControlPlus.Helpers.DateTimeHelper.compose_timestamps(%{foo: "bar"})
  end
end
