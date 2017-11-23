defmodule ControlPlus.Reservation do
  @moduledoc """
  A reservation struct, also takes care of converting the json to a struct
  """

  defstruct [:id, :user_id]

  @spec parse(nil | {any, map}) :: nil | map
  def parse(nil), do: nil
  def parse({_, data}) do
    Enum.reduce(
      data,
      %ControlPlus.Reservation{},
      fn ({key, value}, schedule) ->
        Map.put(schedule, String.to_atom(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
  end
end
