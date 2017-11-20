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
end
