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

  test "should get client details " do
    use_cassette "ctrl_plus/client_details" do
      assert {
               :ok,
               %{
                 club_card_amount: nil,
                 sales: "",
                 zipcode: nil,
                 id: 1017831,
                 lastname: nil,
                 members_interjection: "",
                 members_address: "Somestreet 1",
                 email: nil,
                 phone: nil,
                 members_sex: "F",
                 comment: nil,
                 personal_coach: "",
                 bank_account: "NL08INGB0123456789",
                 members_phone: "",
                 birthday: "1981-06-24",
                 address: nil,
                 __struct__: ControlPlus.User,
                 members_lastname: "Doe",
                 json_code: "14",
                 members_city: "Utrecht",
                 country: "Netherlands",
                 mob_phone: nil,
                 interjection: nil,
                 updated_at: nil,
                 club_id: "",
                 members_name: "Jane",
                 members_mob_phone: "0612345678",
                 members_zipcode: "1111AB",
                 members_email: "jane@doe.com",
                 province: "",
                 sex: nil,
                 member_number: nil,
                 labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                 campaign: "",
                 photo: nil,
                 brought_by: "",
                 name: nil,
                 city: nil,
                 entered: "Web-in"
               }
             } == ControlPlus.Api.client_details(1017831)
    end
  end

  test "should get a list of activities" do
    use_cassette "ctrl_plus/get_activities" do
      assert {
               :ok,
               %{
                 schedule: %{
                   18 => %ControlPlus.Activity{
                     end_date: ~D[2017-06-05],
                     id: 17916,
                     name: "MURPH special",
                     schedule: %{
                       start: ~T[09:00:00],
                       weekday: 1
                     },
                     start_date: ~D[2017-06-05],
                     sub_type_id: 0
                   },
                   129 => %ControlPlus.Activity{
                     end_date: ~D[2019-03-17],
                     id: 16939,
                     name: "Your personal coach",
                     schedule: %{
                       start: ~T[10:00:00],
                       weekday: 6
                     },
                     start_date: ~D[2017-02-27],
                     sub_type_id: 0
                   },
                   166 => %ControlPlus.Activity{
                     end_date: ~D[2023-03-17],
                     id: 18337,
                     name: "Your personal coach",
                     schedule: %{
                       start: ~T[20:15:00],
                       weekday: 2
                     },
                     start_date: ~D[2017-02-27],
                     sub_type_id: 0
                   }
                 }
               }
             } == ControlPlus.Api.activities()
    end
  end
end
