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
    :activity_definition_id,
    :image,
    :name,
    :price,
    :schedule,
    :staff_id,
    :start,
    :starts_on,
    :starts_at,
    :status,
    :sub_type_id,
    :staff_name,

  ]

  @mapping %{
    "capacity" => :max_capacity,
    "activity_id" => :activity_definition_id,
    "activity_id_name" => :name,
    "enddate" => :end_date,
    "endtime" => :end_time,
    "ext_description" => :description_long,
    "shedule" => :schedule,
    "startdate" => :starts_on,
    "start_time" => :starts_at,
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
    result = Map.put(activities, :schedule, schedule)
#    {ControlPlus.Helpers.CastHelper.cast(id), result}
    result
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))
end
