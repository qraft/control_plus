defmodule ControlPlus.Helpers.DateTimeHelper do
  @moduledoc """
  This module provides several date helpers
  """

  @spec format_date_time_for_api(DateTime.t, :reversed | nil) :: String.t
  def format_date_time_for_api(date_time, option \\ nil)
  def format_date_time_for_api(date_time, :reversed) do
    Timex.format!(date_time, "%Y/%m/%d %H:%M:%S", :strftime)
  end
  def format_date_time_for_api(date_time, _) do
    Timex.format!(date_time, "%d/%m/%Y %H:%M:%S", :strftime)
  end

  @spec format_date_time(DateTime.t) :: String.t
  def format_date_time(%DateTime{} = dt) do
    Timex.format!(dt, "%d/%m/%Y %H:%M:%S", :strftime)
  end

  def naive_to_utc(%NaiveDateTime{} = datetime) do
    case Calendar.DateTime.from_naive(datetime, "Europe/Amsterdam") do
      {:ok, timezoned} -> Calendar.DateTime.shift_zone(timezoned, "Etc/UTC")
      error -> error
    end
  end

  def naive_to_utc(%Date{} = date, %Time{} = time) do
    with {:ok, naive} <- NaiveDateTime.new(date, time),
         {:ok, timezoned} <- Calendar.DateTime.from_naive(naive, "Europe/Amsterdam")
      do
      Calendar.DateTime.shift_zone(timezoned, "Etc/UTC")
    else
      error -> error
    end
  end

  def naive_to_utc!(%NaiveDateTime{} = datetime) do
    {:ok, utc} = naive_to_utc(%NaiveDateTime{} = datetime)
    utc
  end
  def naive_to_utc!(%Date{} = date, %Time{} = time) do
    {:ok, utc} = naive_to_utc(date, time)
    utc
  end

  def compose_timestamps(
        data,
        %{date: %Date{} = date, start_time: %Time{} = start_time, end_time: %Time{} = end_time}
      ) do
    data
    |> process_timestamp(:starts_at, date, start_time)
    |> process_timestamp(:ends_at, date, end_time)
  end
  def compose_timestamps(data, %{date: %Date{} = date, start_time: %Time{} = start_time}) do
    process_timestamp(data, :starts_at, date, start_time)
  end
  def compose_timestamps(%{date: date, start: time} = data, _time) when not is_nil(date) and not is_nil(time) do
    process_timestamp(data, :starts_at, date, time)
  end
  def compose_timestamps(data), do: data

  defp process_timestamp(data, field, date, time) do
    case naive_to_utc(date, time) do
      {:ok, datetime} -> Map.put(data, field, datetime)
      _ -> data
    end
  end
end
