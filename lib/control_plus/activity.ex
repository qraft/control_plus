defmodule ControlPlus.Activity do
  @moduledoc """
  An Activity struct, also takes care of converting the json to a struct
  """

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
    :status,
    :capacity,
    :description,
    :description_long,
    :image,
    :staff_id

  ]

  @mapping %{
    "activity_id_name" => :name,
    "enddate" => :end_date,
    "startdate" => :start_date,
    "activity_id" => :id,
    "shedule" => :schedule,
    "ext_description" => :description_long,
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
    schedule = ControlPlus.Schedule.parse(activities.schedule)
    result = Map.put(activities, :schedule, schedule)
    {ControlPlus.Helpers.CastHelper.cast(id), result}
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))
end
