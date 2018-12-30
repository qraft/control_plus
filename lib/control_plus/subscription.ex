defmodule ControlPlus.Subscription do
  @moduledoc """
  A subscription struct, also takes care of converting the json to a struct
  """

  defstruct [
    :id,
    :type,
    :type_id,
    :type_name,
    :max_visit,
    :stop_date,
    :start_date,
    :end_date,
    :last_visit,
    :visit_done
  ]

  @mapping %{
    "inscr_id" => :id,
    "inscrtype_type" => :type,
    "inscrtype_id" => :type_id,
    "inscrtype_name" => :type_name,
    "inscr_maxvisit" => :max_visit,
    "inscr_stop_date" => :stop_date,
    "inscr_startdate" => :start_date,
    "inscr_enddate" => :end_date,
    "inscr_last_visit" => :last_visit,
    "inscr_visitdone" => :visit_done
  }

  @spec parse(map) :: map
  def parse(nil), do: %ControlPlus.Subscription{}
  def parse(%{} = subscription) when subscription == %{}, do: %ControlPlus.Subscription{}
  def parse(data) do
    Enum.reduce(
      data,
      %ControlPlus.Subscription{},
      fn ({key, value}, subscription) ->
        Map.put(subscription, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
      end
    )
  end

  @spec map_key(String.t) :: atom
  defp map_key(key) when is_binary(key), do: Map.get(@mapping, key, String.to_atom(key))
  defp map_key(key) when is_atom(key), do: Map.get(@mapping, Atom.to_string(key), key)
end
