defmodule ControlPlus.Helpers.TimeHelper do
  @moduledoc """
  This module provides several time helpers
  """
  %{
    date: nil,
    end_date: ~D[2019-03-17],
    end_time: nil,
    ends_at: nil,
    start: nil,
    start_date: ~D[2017-02-27],
    start_time: nil,
    starts_at: nil
  }

  def compose_timestamps(%{date: date, start: time} = data, _time) when not is_nil(date) and not is_nil(time) do
    process_timestamp(data, :starts_at, date, time)
  end
  def compose_timestamps(%{date: date, start: nil} = data) when not is_nil(date) do
    process_timestamp(data, :starts_at, date, ~T[00:00:00])
  end
  def compose_timestamps(%{start_date: date, } = data, time) when not is_nil(date) and not is_nil(time) do
    process_timestamp(data, :starts_at, date, time)
  end
  def compose_timestamps(%{start_date: date, } = data, nil) when not is_nil(date) do
    process_timestamp(data, :starts_at, date, ~T[00:00:00])
  end
  def compose_timestamps(%{start_date: date, start_time: nil} = data) when not is_nil(date) do
    process_timestamp(data, :starts_at, date, ~T[00:00:00])
  end
  def compose_timestamps(%{start_date: date, start_time: time} = data) when not is_nil(date) do
    process_timestamp(data, :starts_at, date, time)
  end
  def compose_timestamps(%{end_date: date, end_time: nil} = data) when not is_nil(date) do
    process_timestamp(data, :ends_at, date, ~T[00:00:00])
  end
  def compose_timestamps(%{end_date: date, end_time: time} = data) when not is_nil(date) do
    process_timestamp(data, :ends_at, date, time)
  end
  def compose_timestamps(data), do: data
  def compose_timestamps(data, _), do: data

  @spec format_time(Time.t) :: String.t
  def format_time(%Time{} = time) do
    "#{time.hour}:#{time.minute}:#{time.second}"
  end

  @spec parse(String.t) :: {:ok, Time.t} | {:error, String.t}
  def parse(string) when is_binary(string) do
    case Regex.named_captures(~r/^(?<hour>\d{2})\:(?<minute>\d{2})\:(?<second>\d{2})$/, string) do
      %{"hour" => hour, "minute" => minute, "second" => second} -> Time.new(to_i(hour), to_i(minute), to_i(second))
      _ -> {:error, "could not parse #{string}"}
    end
  end

  @spec parse!(binary) :: Time.t
  def parse!(string) when is_binary(string) do
    {:ok, date} = parse(string)
    date
  end

  defp to_i(binary), do: String.to_integer(binary)

  defp process_timestamp(data, field, date, time) do
    case NaiveDateTime.new(date, time) do
      {:ok, datetime} -> Map.put(data, field, datetime)
      _ -> data
    end
  end

end
