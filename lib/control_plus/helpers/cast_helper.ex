defmodule ControlPlus.Helpers.CastHelper do
  @moduledoc """
  This module contains helpers for type casting a string
  """

  @doc """
  This will try to convert a given `String.t` to `Date.t`, `Time.t` or `integer` and on failure just returns the value as is
  """
  @spec cast(any) :: any
  def cast(value) when is_binary(value) do
    value
    |> maybe_cast_to_date
    |> maybe_cast_to_time
    |> maybe_cast_to_int
    |> maybe_cast_to_float
  end
  def cast(value), do: value

  @spec maybe_cast_to_int(any) :: any
  #numbers like "0612345678" should stay string else it drops the leading 0
  defp maybe_cast_to_int("0"), do: 0
  defp maybe_cast_to_int("0" <> _rest = value) when is_binary(value), do: value
  defp maybe_cast_to_int(value) when is_binary(value)  do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> value
    end
  end
  defp maybe_cast_to_int(value), do: value

  @spec maybe_cast_to_float(any) :: any
  defp maybe_cast_to_float(value) when is_binary(value) do
    with true <- Regex.match?(~r/^\d+\.\d+$/, value),
         {float, ""} <- Float.parse(value)
      do
      float
    else
      _ -> value
    end
  end
  defp maybe_cast_to_float(value), do: value

  @spec maybe_cast_to_date(any) :: any
  defp maybe_cast_to_date(value) when is_binary(value) do
    case ControlPlus.Helpers.DateHelper.parse(value) do
      {:ok, %Date{} = date} -> date
      _ -> value
    end
  end
  #  defp maybe_cast_to_date(value), do: value

  @spec maybe_cast_to_time(any) :: any
  defp maybe_cast_to_time(value) when is_binary(value) do
    case ControlPlus.Helpers.TimeHelper.parse(value) do
      {:ok, %Time{} = date} -> date
      _ -> value
    end
  end
  defp maybe_cast_to_time(value), do: value
end
