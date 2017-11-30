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
end
