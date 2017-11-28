defmodule ControlPlus.ClientTest do
  use ExUnit.Case
  @client_struct %ControlPlus.Client{
    address: "Somestreet 1",
    bank_account: "NL08INGB0123456789",
    birthdate: ~D[1981-06-24],
    city: "Utrecht",
    comment: "Afvallers /niet geselecteerd/ in de toekomst contacten",
    country: "Netherlands",
    email: "jane@doe.com",
    interjection: 12345,
    lastname: "Doe",
    mobile_phone: "0612345678",
    name: "Jane",
    password: "test123",
    gender: "F",
    zipcode: "1111AB",
  }

  test "it can convert a client to post params" do

    assert [
             address: "Somestreet 1",
             bank_account: "NL08INGB0123456789",
             birthday: "24/06/1981",
             city: "Utrecht",
             comment: "Afvallers /niet geselecteerd/ in de toekomst contacten",
             country_id: 159,
             email: "jane@doe.com",
             interjection: "12345",
             lastname: "Doe",
             mob_phone: "0612345678",
             name: "Jane",
             password: "test123",
             sex: "F",
             zipcode: "1111AB"
           ] == ControlPlus.Client.to_post_params(@client_struct)
  end

  test "it can convert a client to post params with missing data" do
    client = Map.delete(@client_struct, :country)
    assert [
             address: "Somestreet 1",
             bank_account: "NL08INGB0123456789",
             birthday: "24/06/1981",
             city: "Utrecht",
             comment: "Afvallers /niet geselecteerd/ in de toekomst contacten",
             email: "jane@doe.com",
             interjection: "12345",
             lastname: "Doe",
             mob_phone: "0612345678",
             name: "Jane",
             password: "test123",
             sex: "F",
             zipcode: "1111AB"
           ] = ControlPlus.Client.to_post_params(client)
  end
end