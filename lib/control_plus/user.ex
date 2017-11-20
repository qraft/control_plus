defmodule ControlPlus.User do
  @moduledoc """
  A User struct, also takes care of converting the json to a struct
  """

  defstruct [
    :id,
    :address,
    :birthday,
    :brought_by,
    :campaign,
    :city,
    :club_card_amount,
    :comment,
    :country,
    :email,
    :entered,
    :interjection,
    :labels,
    :lastname,
    :member_number,
    :mob_phone,
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

  @spec parse({String.t, map}) :: map
  def parse({id, data}) do
    data
    |> Enum.reduce(
         %ControlPlus.User{},
         fn ({key, value}, client) ->
           Map.put(client, String.to_atom(key), value)
         end
       )
    |> Map.put(:id, String.to_integer(id))
  end
end
