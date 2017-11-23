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


  @spec map_key(String.t) :: atom
  defp map_key(key), do: Map.get(@mapping, key, String.to_atom(key))
end
