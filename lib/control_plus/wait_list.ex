defmodule ControlPlus.WaitList do
  @moduledoc """
  A reservation struct, also takes care of converting the json to a struct
  """

  #TODO get an actual result with a filled waitlist
  # {"1", %{"id" => "20808", "user_id" => "1215309", "user_name" => "Amarantha Bakker"}}
  defstruct [:activity_title, :end_time, :waitlist]

  @spec parse(map) :: map
  def parse(nil), do: nil
  def parse(data) do
    cast_data = Enum.reduce(
      data,
      %ControlPlus.WaitList{},
      fn ({key, value}, waitlist) ->
        Map.put(waitlist, String.to_atom(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )

    case cast_data do
      %{waitlist: waitlist} when waitlist == %{} -> Map.put(cast_data, :waitlist, [])
      %{waitlist: waitlist} -> Map.put(cast_data, :waitlist, parse_waitlist(waitlist))
    end
  end

  defp parse_waitlist(entry) do
    entry
    |> Map.keys
    |> Enum.map(
         fn key ->
           entry
           |> Kernel.get_in([key, "user_id"])
           |> String.to_integer
         end
       )
  end
end
