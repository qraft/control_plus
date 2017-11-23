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
    |> maybe_cast_to_nil
  end
  def cast(value), do: value

  def reverse_cast(value) do
    value
    |> maybe_reverse_cast_date
  end

  @doc "Coverts a map with string keys to atom keys and casts the values"
  @spec string_map_to_casted_atom(map) :: map
  def string_map_to_casted_atom(%{} = data) do
    Enum.reduce(
      data,
      %{},
      fn {k, v}, map ->
        Map.put(map, String.to_atom(k), ControlPlus.Helpers.CastHelper.cast(v))
      end
    )
  end

  @doc "coverts a map to a keyword list"
  @spec map_to_keyword(map) :: keyword
  def map_to_keyword(%{} = data), do: Enum.map(data, fn {k, v} -> {String.to_atom(k), v} end)

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
      {:ok, %Time{} = time} -> time
      _ -> value
    end
  end
  defp maybe_cast_to_time(value), do: value

  @spec maybe_cast_to_nil(any) :: any
  defp maybe_cast_to_nil(""), do: nil
  defp maybe_cast_to_nil(value), do: value

  @spec maybe_reverse_cast_date(any) :: String.t
  defp maybe_reverse_cast_date(%Date{} = date), do: ControlPlus.Helpers.DateHelper.format_date_for_api(date)
  defp maybe_reverse_cast_date(value), do: "#{value}"
end
