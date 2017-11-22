defmodule ControlPlus.Activity do
  @moduledoc """
  An Activity struct, also takes care of converting the json to a struct
  """

  #TODO cast end_date and start_date to actual Date objects
  defstruct [
    :id,
    :name,
    :count,
    :start,
    :date,
    :end_date,
    :schedule,
    :start_date,
    :sub_type_id,
    :price,
    :status
  ]

  @mapping %{
    "activity_id_name" => :name,
    "enddate" => :end_date,
    "startdate" => :start_date,
    "activity_id" => :id,
    "shedule" => :schedule,
  }

  @spec parse({String.t, map}) :: {integer, map}
  def parse({id, data}) do
    activities = Enum.reduce(
      data,
      %ControlPlus.Activity{},
      fn ({key, value}, client) ->
        Map.put(client, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
    schedule = cast_schedule(activities.schedule)
    result = Map.put(activities, :schedule, schedule)
    {ControlPlus.Helpers.CastHelper.cast(id), result}
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))

  defp cast_schedule(nil), do: nil
  defp cast_schedule(
         %{
           "1" => %{
             "start" => start_time,
             "weekday" => weekday
           }
         }
       ) do
    %{
      start: ControlPlus.Helpers.CastHelper.cast(start_time),
      weekday: ControlPlus.Helpers.CastHelper.cast(weekday)
    }
  end
#  defp cast_schedule(schedule), do: schedule
end
