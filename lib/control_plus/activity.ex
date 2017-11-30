defmodule ControlPlus.Activity do
  @moduledoc """
  An Activity struct, also takes care of converting the json to a struct
  """

  defstruct [
    :control_plus_id,
    :count,
    :date,
    :description,
    :description_long,
    :duration_in_minutes,
    :end_date,
    :end_time,
    :ends_at,
    :image,
    :max_capacity,
    :name,
    :price,
    :schedule,
    :staff_id,
    :staff_name,
    :start,
    :start_date,
    :start_time,
    :starts_at,
    :status,
    :sub_type_id,
  ]

  @mapping %{
    "capacity" => :max_capacity,
    "activity_id" => :control_plus_id,
    "activity_id_name" => :name,
    "enddate" => :end_date,
    "endtime" => :end_time,
    "ext_description" => :description_long,
    "shedule" => :schedule,
    "startdate" => :start_date,
    "start_time" => :start_time,
  }

  #TODO calc duration using start_time and end_time
  @spec parse({String.t, map}, Date.t) :: %ControlPlus.Activity{}
  def parse({_id, data}, date) do
    activities = Enum.reduce(
      data,
      %ControlPlus.Activity{},
      fn ({key, value}, client) ->
        Map.put(client, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )

    schedule = ControlPlus.Schedule.parse(activities.schedule)

    activities
    |> Map.delete(:schedule)
    |> ControlPlus.Helpers.DateTimeHelper.compose_timestamps(%{date: date, time: schedule.start_time})
    |> maybe_set_duration
    #    {ControlPlus.Helpers.CastHelper.cast(id), result}

  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))

  defp maybe_set_duration(%{start_time: %Time{} = start_time, end_time: %Time{} = end_time} = data) do
    duration = end_time
               |> Time.diff(start_time)
               |> Kernel./(60)
               |> Kernel.round

    Map.put(data, :duration_in_minutes, duration)
  end
  defp maybe_set_duration(data), do: data
end
