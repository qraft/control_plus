defmodule ControlPlus.Helpers.DateHelper do
  @moduledoc """
  This module provides several date helpers
  """

  @spec format_date(Date.t) :: String.t
  def format_date(date) do
    Timex.format!(date, "{YYYY}-{0M}-{0D}")
  end

  @spec format_date_days_ago(non_neg_integer) :: String.t
  def format_date_days_ago(days) do
    Timex.today
    |> Timex.shift(days: -(days))
    |> format_date
  end

  @spec format_date_days_from_now(non_neg_integer) :: String.t
  def format_date_days_from_now(days) do
    Timex.today
    |> Timex.shift(days: days)
    |> format_date
  end

  @spec format_date_time(DateTime.t) :: String.t
  def format_date_time(%DateTime{} = dt) do
    Timex.format!(dt, "%d/%m/%Y %H:%M:%S", :strftime)
  end

  @spec parse(String.t) :: {:ok, Date.t} | {:error, String.t}
  def parse(string) do
    case machine_notation(string) do
      {:ok, _date} = result -> result
      _ -> human_notation(string)
    end
  end

  @spec parse!(String.t) :: Date.t
  def parse!(string) do
    {:ok, date} = parse(string)
    date
  end

  @spec to_i(String.t) :: number
  defp to_i(binary), do: String.to_integer(binary)

  @spec machine_notation(String.t) :: {:ok, Date.t} | {:error, String.t}
  defp machine_notation(string) do
    case Regex.named_captures(~r/^(?<year>\d{4})[-|\/](?<month>\d{2})[-|\/](?<day>\d{2})$/, string) do
      %{"day" => day, "month" => month, "year" => year} -> Date.new(to_i(year), to_i(month), to_i(day))
      _ -> {:error, "could not parse #{string}"}

    end
  end

  @spec human_notation(String.t) :: {:ok, Date.t} | {:error, String.t}
  defp human_notation(string) do
    case Regex.named_captures(~r/^(?<day>\d{2})[-|\/](?<month>\d{2})[-|\/](?<year>\d{4})$/, string) do
      %{"day" => day, "month" => month, "year" => year} -> Date.new(to_i(year), to_i(month), to_i(day))
      _ -> {:error, "could not parse #{string}"}
    end
  end
end
