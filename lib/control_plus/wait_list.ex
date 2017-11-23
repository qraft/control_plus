defmodule ControlPlus.WaitList do
  @moduledoc """
  A reservation struct, also takes care of converting the json to a struct
  """

  #TODO get an actual result with a filled waitlist
  defstruct [:activity_title, :end_time, :waitlist]

  @spec parse(map) :: map
  def parse(nil), do: nil
  def parse(data) do
    Enum.reduce(
      data,
      %ControlPlus.WaitList{},
      fn ({key, value}, schedule) ->
        Map.put(schedule, String.to_atom(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
  end
end
