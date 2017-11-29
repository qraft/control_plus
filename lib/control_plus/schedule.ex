defmodule ControlPlus.Schedule do
  @moduledoc """
  A schedule struct, also takes care of converting the json to a struct
  """

  defstruct [:available, :start_time, :starts_at, :waitlist_size, :weekday]

  @mapping %{"start" => :start_time}

  @spec parse(map) :: map
  def parse(nil), do: %ControlPlus.Schedule{}
  def parse(%{} = schedule) when schedule == %{}, do: %ControlPlus.Schedule{}
  def parse(%{"1" => data}) do
    Enum.reduce(
      data,
      %ControlPlus.Schedule{},
      fn ({key, value}, schedule) ->
        Map.put(schedule, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))

end
