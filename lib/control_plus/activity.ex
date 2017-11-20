defmodule ControlPlus.Activity do
  @moduledoc """
  An Activity struct, also takes care of converting the json to a struct
  """

  defstruct [
    :id,
    :name,
    :end_date,
    :schedule,
    :start_date,
    :sub_type_id
  ]

  @mapping %{
    "activity_id_name" => :name,
    "enddate" => :end_date,
    "startdate" => :start_date,
    "activity_id" => :id,
    "shedule" => :schedule
  }

  @spec parse(map) :: [%ControlPlus.Activity{}]
  def parse(data) do
    Enum.reduce(
      data,
      %ControlPlus.Activity{},
      fn ({key, value}, client) ->
        Map.put(client, map_key(key), value)
      end
    )
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))
end
