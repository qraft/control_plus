defmodule ControlPlus.Reservation do
  @moduledoc """
  A reservation struct, also takes care of converting the json to a struct
  """

  defstruct [:id, :control_plus_user_id]
  @mapping %{"user_id" => :control_plus_user_id}

  @spec parse(nil | {any, map}) :: nil | map
  def parse(nil), do: nil
  def parse({_, data}) do
    Enum.reduce(
      data,
      %ControlPlus.Reservation{},
      fn ({key, value}, schedule) ->
        Map.put(schedule, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
  end


  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))
end
