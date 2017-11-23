defmodule ControlPlus.Activity do
  @moduledoc """
  An Activity struct, also takes care of converting the json to a struct
  """

  defstruct [
    :capacity,
    :count,
    :date,
    :description,
    :description_long,
    :end_date,
    :end_time,
    :id,
    :image,
    :name,
    :price,
    :schedule,
    :staff_id,
    :start,
    :start_date,
    :start_time,
    :status,
    :sub_type_id,
    :staff_name,

  ]

  @mapping %{
    "activity_id" => :id,
    "activity_id_name" => :name,
    "enddate" => :end_date,
    "endtime" => :end_time,
    "ext_description" => :description_long,
    "shedule" => :schedule,
    "startdate" => :start_date,
    "starttime" => :start_time,
  }

  @spec parse({String.t, map}) :: %ControlPlus.Activity{}
  def parse({id, data}) do
    activities = Enum.reduce(
      data,
      %ControlPlus.Activity{},
      fn ({key, value}, client) ->
        Map.put(client, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
    schedule = ControlPlus.Schedule.parse(activities.schedule)
    result = Map.put(activities, :schedule, schedule)
#    {ControlPlus.Helpers.CastHelper.cast(id), result}
    result
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))
end
