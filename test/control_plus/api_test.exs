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
                     capacity: nil,
                     count: nil,
                     date: nil,
                     description: nil,
                     description_long: nil,
                     end_date: ~D[2017-06-05],
                     id: 17916,
                     image: nil,
                     name: "MURPH special",
                     price: nil,
                     schedule: %ControlPlus.Schedule{
                       available: nil,
                       start: ~T[09:00:00],
                       waitlist_size: nil,
                       weekday: 1
                     },
                     staff_id: nil,
                     start: nil,
                     start_date: ~D[2017-06-05],
                     status: nil,
                     sub_type_id: 0
                   },
                   129 => %ControlPlus.Activity{
                     capacity: nil,
                     count: nil,
                     date: nil,
                     description: nil,
                     description_long: nil,
                     end_date: ~D[2019-03-17],
                     id: 16939,
                     image: nil,
                     name: "Your personal coach",
                     price: nil,
                     schedule: %ControlPlus.Schedule{
                       available: nil,
                       start: ~T[10:00:00],
                       waitlist_size: nil,
                       weekday: 6
                     },
                     staff_id: nil,
                     start: nil,
                     start_date: ~D[2017-02-27],
                     status: nil,
                     sub_type_id: 0
                   },
                   166 => %ControlPlus.Activity{
                     capacity: nil,
                     count: nil,
                     date: nil,
                     description: nil,
                     description_long: nil,
                     end_date: ~D[2023-03-17],
                     id: 18337,
                     image: nil,
                     name: "Your personal coach",
                     price: nil,
                     schedule: %ControlPlus.Schedule{
                       available: nil,
                       start: ~T[20:15:00],
                       waitlist_size: nil,
                       weekday: 2
                     },
                     staff_id: nil,
                     start: nil,
                     start_date: ~D[2017-02-27],
                     status: nil,
                     sub_type_id: 0
                   }
                 }
               }
             } == ControlPlus.Api.activities()
    end
  end

  test "member_visits_for_sync" do
    use_cassette "ctrl_plus/member_visits" do
      {
        :ok,
        %{
          activities: %{
            16 => %ControlPlus.Activity{
              count: 1,
              date: ~D[2017-05-08],
              end_date: nil,
              id: 16443,
              name: "PowerBuilding Deadlift",
              price: nil,
              schedule: nil,
              start: ~T[19:00:00],
              start_date: nil,
              status: 0,
              sub_type_id: nil
            },
            27 => %ControlPlus.Activity{
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
            }
          }
        }
      } = ControlPlus.Api.member_visits(1016503)
    end
  end

  test "activity details" do
    use_cassette "ctrl_plus/activity_details" do
      assert {
               :ok,
               %{
                 activities: %{
                   5 => %{
                     __struct__: ControlPlus.Activity,
                     capacity: 24,
                     count: nil,
                     date: nil,
                     description: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\nLevel 1\n</body>\n</html>",
                     description_long: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\n\n</body>\n</html>",
                     end_date: nil,
                     end_time: ~T[18:15:00],
                     id: 16343,
                     image: "/uploads/27/35/85/86/metcon-800x450.jpg",
                     name: "MetCon30",
                     price: nil,
                     schedule: %ControlPlus.Schedule{
                       available: 2,
                       start: ~T[17:45:00],
                       waitlist_size: 0,
                       weekday: nil
                     },
                     staff_id: nil,
                     staff_name: nil,
                     start: nil,
                     start_date: nil,
                     start_time: ~T[17:45:00],
                     status: nil,
                     sub_type_id: nil
                   },
                   11 => %{
                     __struct__: ControlPlus.Activity,
                     capacity: 12,
                     count: nil,
                     date: nil,
                     description: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\nlevel 1\n</body>\n</html>",
                     description_long: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\n\n</body>\n</html>",
                     end_date: nil,
                     end_time: ~T[20:00:00],
                     id: 18575,
                     image: "/uploads/27/88/24/13/app_bg_bench.jpg",
                     name: "PowerBuilding Bench",
                     price: nil,
                     schedule: %ControlPlus.Schedule{
                       available: 4,
                       start: ~T[19:00:00],
                       waitlist_size: 0,
                       weekday: nil
                     },
                     staff_id: nil,
                     staff_name: nil,
                     start: nil,
                     start_date: nil,
                     start_time: ~T[19:00:00],
                     status: nil,
                     sub_type_id: nil
                   }
                 }
               }
             } == ControlPlus.Api.activity_details()
    end
  end

  test "it can get reservations" do
    use_cassette "ctrl_plus/get_reservations" do
      date_time = DateTime.from_naive!(~N[2017-11-23 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               %{
                 reservations: [%ControlPlus.Reservation{id: 2758360, user_id: 1251776},
                   %ControlPlus.Reservation{id: 2759008, user_id: 1247568},
                   %ControlPlus.Reservation{id: 2759608, user_id: 1215297},
                   %ControlPlus.Reservation{id: 2761606, user_id: 1243171},
                   %ControlPlus.Reservation{id: 2762629, user_id: 1239420},
                   %ControlPlus.Reservation{id: 2763348, user_id: 1245300},
                   %ControlPlus.Reservation{id: 2767447, user_id: 1211655},
                   %ControlPlus.Reservation{id: 2768876, user_id: 1233832}]
               }
             } == ControlPlus.Api.reservations(18575, date_time)
    end
  end

  test "it can get a waitlist" do
    use_cassette "ctrl_plus/wait_list" do
      date_time = DateTime.from_naive!(~N[2017-11-23 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               %ControlPlus.WaitList{
                 activity_title: "PowerBuilding Bench",
                 end_time: ~T[20:00:00],
                 waitlist: %{}
               }
             } == ControlPlus.Api.wait_list(18575, date_time)
    end
  end
end
