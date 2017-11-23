defmodule ControlPlus.Client do
  @moduledoc """
  A User struct, also takes care of converting the json to a struct
  """

  defstruct [
    :address,
    :bank_account,
    :birthday,
    :brought_by,
    :campaign,
    :city,
    :club_card_amount,
    :club_id,
    :comment,
    :country,
    :email,
    :entered,
    :id,
    :interjection,
    :json_code,
    :labels,
    :lastname,
    :member_number,
    :mobile_phone,
    :name,
    :password,
    :personal_coach,
    :phone,
    :photo,
    :province,
    :sales,
    :sex,
    :updated_at,
    :zipcode
  ]

  @mapping %{
    "members_address" => :address,
    "members_city" => :city,
    "members_email" => :email,
    "members_interjection" => :interjection,
    "members_lastname" => :lastname,
    "members_mob_phone" => :mobile_phone,
    "mob_phone" => :mobile_phone,
    "members_name" => :name,
    "members_phone" => :phone,
    "members_sex" => :sex,
    "members_zipcode" => :zipcode,
  }

  @country_id_mapping %{"Netherlands" => 159, "Belgium" => 20}

  @spec parse({String.t, map}) :: map
  def parse({id, data}) do
    data
    |> Enum.reduce(
         %ControlPlus.Client{},
         fn ({key, value}, client) ->
           Map.put(client, map_key(key), ControlPlus.Helpers.CastHelper.cast(value))
         end
       )
    |> Map.put(:id, ControlPlus.Helpers.CastHelper.cast(id))
  end

  @doc "Takes a %ControlPlus.Client{} struct and transforms that to a map which is accepted by the api to post"
  @spec to_post_params(%ControlPlus.Client{}) :: map
  def to_post_params(%ControlPlus.Client{} = client) do
    client
    |> Map.delete(:__struct__)
    |> reverse_map_and_filter_nils
    |> replace_country
    |> ControlPlus.Helpers.CastHelper.map_to_keyword
  end

  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))

  @spec reverse_map_and_filter_nils(map) :: map
  defp reverse_map_and_filter_nils(params) do
    Enum.reduce(
      params,
      %{},
      fn {key, value}, list ->
        if (value != nil) do
          Map.put(list, reverse_map_key(key), ControlPlus.Helpers.CastHelper.reverse_cast(value))
        else
          list
        end
      end
    )
  end

  @spec reverse_map_key(:atom) :: String.t
  defp reverse_map_key(key) do
    case Enum.find(@mapping, fn {_reversed_key, val} -> val == key end) do
      {reversed_key, _} -> String.replace(reversed_key, "members_", "")
      _ -> Atom.to_string(key)
    end
  end

  @spec replace_country(map) :: map
  defp replace_country(%{"country" => country} = params) do
    country_id = Map.get(@country_id_mapping, country, 0)
    params
    |> Map.delete("country")
    |> Map.put("country_id", country_id)
  end
  defp replace_country(params), do: params
end
