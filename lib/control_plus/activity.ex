defmodule ControlPlus.Activity do
  @moduledoc """
  An Activity struct, also takes care of converting the json to a struct
  """

  defstruct [
    :max_capacity,
    :count,
    :date,
    :description,
    :description_long,
    :end_date,
    :end_time,
    :control_plus_id,
    :image,
    :name,
    :price,
    :schedule,
    :staff_id,
    :start,
    :start_date,
    :start_time,
    :starts_at,
    :ends_at,
    :status,
    :sub_type_id,
    :staff_name,

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

  @spec parse({String.t, map}) :: %ControlPlus.Activity{}
  def parse({_id, data}) do
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
    |> ControlPlus.Helpers.TimeHelper.compose_timestamps(schedule.start_time)
#    {ControlPlus.Helpers.CastHelper.cast(id), result}

  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))


end
