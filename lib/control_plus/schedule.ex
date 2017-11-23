defmodule ControlPlus.Schedule do
  @moduledoc """
  A schedule struct, also takes care of converting the json to a struct
  """

  defstruct [:start, :weekday, :waitlist_size, :available]

  @mapping %{}

  @spec parse(map) :: map
  def parse(nil), do: nil
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
