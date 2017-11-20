defmodule ControlPlus.Helpers.TimeHelper do
  @moduledoc """
  This module provides several time helpers
  """

  @spec format_time(Time.t) :: String.t
  def format_time(%Time{} = time) do
    "#{time.hour}:#{time.minute}:#{time.second}"
  end

  @spec parse(String.t) :: {:ok, Date.t} | {:error, String.t}
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
end
