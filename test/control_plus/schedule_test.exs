defmodule ControlPlus.ScheduleTest do
  use ExUnit.Case
  test "it can parse schedules" do
    params = %{
      "available" => "1",
      "start_time" => "17:30:00",
      "starts_at" => "2017-12-04",
      "waitlist_size" => "4",
      "weekday" => 1
    }


    assert %ControlPlus.Schedule{} == ControlPlus.Schedule.parse(nil)
    assert %ControlPlus.Schedule{} == ControlPlus.Schedule.parse(%{})
    assert %ControlPlus.Schedule{
             available: 1,
             start_time: ~T[17:30:00],
             starts_at: ~D[2017-12-04],
             waitlist_size: 4,
             weekday: 1
           } == ControlPlus.Schedule.parse(%{"1" => params})
  end
end
