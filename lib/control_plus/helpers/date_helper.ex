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

  @spec parse(String.t) :: {:ok, Date.t} | {:error, String.t}
  def parse(string) do
    case Regex.named_captures(~r/^(?<day>\d{2})\/(?<month>\d{2})\/(?<year>\d{4})$/, string) do
      %{"day" => day, "month" => month, "year" => year} -> Date.new(to_i(year), to_i(month), to_i(day))
      _ -> {:error, "could not parse #{string}"}

    end
  end

  @spec parse!(String.t) :: Date.t
  def parse!(string) do
    {:ok, date} = parse(string)
    date
  end

  defp to_i(binary), do: String.to_integer(binary)
end
