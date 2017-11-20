defmodule ControlPlusTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
    :ok
  end

  test "should get a list of clients" do
    use_cassette "ctrl_plus/get_clients" do
      assert {
               :ok,
               %{
                 current_page: 1,
                 total_pages: 31,
                 users: [
                   %ControlPlus.User{
                     address: "Somewhere 123",
                     birthday: "1984-06-09",
                     brought_by: "",
                     campaign: "",
                     city: "Den Haag",
                     club_card_amount: "0.0",
                     comment: "Aangemeld bij Demodag. Na telefonische intake afgesproken op de wachtlijst voor pilot 3 of 4 . Stopt per 1 aug. #06  heeft geen rede op gegeven.",
                     country: "Netherlands",
                     email: "test@user.com",
                     entered: "Web-in",
                     id: 1014557,
                     interjection: "",
                     labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                     lastname: "Testuser2",
                     member_number: "45",
                     mob_phone: "0612345678",
                     name: "Test",
                     personal_coach: "",
                     phone: "0612345678\"",
                     photo: "",
                     province: "",
                     sales: "",
                     sex: "F",
                     updated_at: "2017-08-03 13:24:04",
                     zipcode: "2211GB"
                   },
                   %ControlPlus.User{
                     address: "Somestreet 1",
                     birthday: "1967-07-27",
                     brought_by: "",
                     campaign: "",
                     city: "Amsterdam",
                     club_card_amount: "0.0",
                     comment: "Just some comment here",
                     country: "Netherlands",
                     email: "someone@gmail.com",
                     entered: "Web-in",
                     id: 1016570,
                     interjection: "Van den",
                     labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                     lastname: "Testuser",
                     member_number: "24",
                     mob_phone: "",
                     name: "Test",
                     personal_coach: "",
                     phone: "0612345678",
                     photo: "",
                     province: "",
                     sales: "",
                     sex: "M",
                     updated_at: "2017-03-29 14:22:17",
                     zipcode: "1111AA"
                   }
                 ]
               }
             } == ControlPlus.Api.clients()
    end
  end
end
