defmodule ControlPlus.ApiTest do

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
                     birthday: ~D[1984-06-09],
                     brought_by: nil,
                     campaign: nil,
                     city: "Den Haag",
                     club_card_amount: 0.0,
                     comment: "Aangemeld bij Demodag. Na telefonische intake afgesproken op de wachtlijst voor pilot 3 of 4 . Stopt per 1 aug. #06  heeft geen rede op gegeven.",
                     country: "Netherlands",
                     email: "test@user.com",
                     entered: "Web-in",
                     id: 1014557,
                     interjection: nil,
                     labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                     lastname: "Testuser2",
                     member_number: 45,
                     mob_phone: "0612345678",
                     name: "Test",
                     personal_coach: nil,
                     phone: "0612345678",
                     photo: nil,
                     province: nil,
                     sales: nil,
                     sex: "F",
                     updated_at: "2017-08-03 13:24:04",
                     zipcode: "2211GB"
                   },
                   %ControlPlus.User{
                     address: "Somestreet 1",
                     birthday: ~D[1967-07-27],
                     brought_by: nil,
                     campaign: nil,
                     city: "Amsterdam",
                     club_card_amount: 0.0,
                     comment: "Just some comment here",
                     country: "Netherlands",
                     email: "someone@gmail.com",
                     entered: "Web-in",
                     id: 1016570,
                     interjection: "Van den",
                     labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                     lastname: "Testuser",
                     member_number: 24,
                     mob_phone: nil,
                     name: "Test",
                     personal_coach: nil,
                     phone: "0612345678",
                     photo: nil,
                     province: nil,
                     sales: nil,
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
                 sales: nil,
                 zipcode: nil,
                 id: 1017831,
                 lastname: nil,
                 members_interjection: nil,
                 members_address: "Somestreet 1",
                 email: nil,
                 phone: nil,
                 members_sex: "F",
                 comment: nil,
                 personal_coach: nil,
                 bank_account: "NL08INGB0123456789",
                 members_phone: nil,
                 birthday: ~D[1981-06-24],
                 address: nil,
                 __struct__: ControlPlus.User,
                 members_lastname: "Doe",
                 json_code: 14,
                 members_city: "Utrecht",
                 country: "Netherlands",
                 mob_phone: nil,
                 interjection: nil,
                 updated_at: nil,
                 club_id: nil,
                 members_name: "Jane",
                 members_mob_phone: "0612345678",
                 members_zipcode: "1111AB",
                 members_email: "jane@doe.com",
                 province: nil,
                 sex: nil,
                 member_number: nil,
                 labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                 campaign: nil,
                 photo: nil,
                 brought_by: nil,
                 name: nil,
                 city: nil,
                 entered: "Web-in"
               }
             } = ControlPlus.Api.client_details(1017831)
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

  test "member_visits_for_sync" do
    use_cassette "ctrl_plus/membe_visits_for_sync" do
      {
        :ok,
        %{
          activities: %{
            1 => %ControlPlus.Activity{
              count: 1,
              date: ~D[2017-08-17],
              end_date: nil,
              id: 18345,
              name: "PowerBuilding Bench",
              price: nil,
              schedule: nil,
              start: ~T[19:00:00],
              start_date: nil,
              status: 0,
              sub_type_id: nil
            },
            2 => %ControlPlus.Activity{
              count: 1,
              date: ~D[2017-09-12],
              end_date: nil,
              id: 16336,
              name: "PowerBuilding Squat",
              price: nil,
              schedule: nil,
              start: ~T[19:00:00],
              start_date: nil,
              status: 0,
              sub_type_id: nil
            }
          }
        }
      } = ControlPlus.Api.member_visits_for_sync(1016503, 100)
    end
  end
end
