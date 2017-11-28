defmodule ControlPlus.ApiTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
    :ok
  end

  test "should get a list of clients" do
    use_cassette "get_clients" do
      assert {
               :ok,
               %{
                 current_page: 1,
                 total_pages: 31,
                 clients: [
                   %ControlPlus.Client{
                     address: "Somewhere 123",
                     birthdate: ~D[1984-06-09],
                     brought_by: nil,
                     campaign: nil,
                     city: "Den Haag",
                     club_card_amount: 0.0,
                     comment: "Aangemeld bij Demodag. Na telefonische intake afgesproken op de wachtlijst voor pilot 3 of 4 . Stopt per 1 aug. #06  heeft geen rede op gegeven.",
                     country: "Netherlands",
                     email: "test@user.com",
                     entered: "Web-in",
                     ext_id: 1014557,
                     interjection: nil,
                     labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                     lastname: "Testuser2",
                     member_number: 45,
                     mobile_phone: "0612345678",
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
                   %ControlPlus.Client{
                     address: "Somestreet 1",
                     birthdate: ~D[1967-07-27],
                     brought_by: nil,
                     campaign: nil,
                     city: "Amsterdam",
                     club_card_amount: 0.0,
                     comment: "Just some comment here",
                     country: "Netherlands",
                     email: "someone@gmail.com",
                     entered: "Web-in",
                     ext_id: 1016570,
                     interjection: "Van den",
                     labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                     lastname: "Testuser",
                     member_number: 24,
                     mobile_phone: nil,
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
             } == ControlPlus.paginated_clients()
    end
  end


  test "should get page 2 from the list of clients" do
    use_cassette "get_clients_page2" do
      assert {:ok, %{current_page: 2}} = ControlPlus.paginated_clients(page: 2)
    end
  end

  test "should get client details " do
    use_cassette "client_details" do
      assert {
               :ok,
               %ControlPlus.Client{
                 address: "Somestreet 1",
                 bank_account: "NL08INGB0123456789",
                 birthdate: ~D[1981-06-24],
                 brought_by: nil,
                 campaign: nil,
                 city: "Utrecht",
                 club_card_amount: nil,
                 club_id: nil,
                 comment: nil,
                 country: "Netherlands",
                 email: "jane@doe.com",
                 entered: "Web-in",
                 ext_id: 1017831,
                 interjection: nil,
                 json_code: 14,
                 labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                 lastname: "Doe",
                 member_number: nil,
                 mobile_phone: "0612345678",
                 name: "Jane",
                 personal_coach: nil,
                 phone: nil,
                 photo: nil,
                 province: nil,
                 sales: nil,
                 sex: "F",
                 updated_at: nil,
                 zipcode: "1111AB"
               }
             } = ControlPlus.client_details(1017831)
    end
  end

  test "should get a list of activities" do
    use_cassette "get_activities" do
      assert {
               :ok,
               [
                 %ControlPlus.Activity{
                   max_capacity: nil,
                   count: nil,
                   date: nil,
                   description: nil,
                   description_long: nil,
                   end_time: nil,
                   image: nil,
                   price: nil,
                   staff_id: nil,
                   staff_name: nil,
                   start: nil,
                   starts_at: nil,
                   status: nil,
                   sub_type_id: 0,
                   end_date: %Date{
                     calendar: Calendar.ISO,
                     day: 17,
                     month: 3,
                     year: 2019
                   },
                   activity_definition_id: 16939,
                   name: "Your personal coach",
                   schedule: %ControlPlus.Schedule{
                     available: nil,
                     waitlist_size: nil,
                     start: %Time{
                       calendar: Calendar.ISO,
                       microsecond: {0, 0},
                       minute: 0,
                       second: 0,
                       hour: 10
                     },
                     weekday: 6
                   },
                   starts_on: %Date{
                     calendar: Calendar.ISO,
                     year: 2017,
                     day: 27,
                     month: 2
                   }
                 },
                 %ControlPlus.Activity{
                   max_capacity: nil,
                   count: nil,
                   date: nil,
                   description: nil,
                   description_long: nil,
                   end_time: nil,
                   image: nil,
                   name: "Your personal coach",
                   price: nil,
                   staff_id: nil,
                   staff_name: nil,
                   start: nil,
                   starts_on: ~D[2017-02-27],
                   starts_at: nil,
                   status: nil,
                   sub_type_id: 0,
                   end_date: %Date{
                     calendar: Calendar.ISO,
                     day: 17,
                     month: 3,
                     year: 2023
                   },
                   activity_definition_id: 18337,
                   schedule: %ControlPlus.Schedule{
                     available: nil,
                     waitlist_size: nil,
                     start: %Time{
                       calendar: Calendar.ISO,
                       microsecond: {0, 0},
                       second: 0,
                       hour: 20,
                       minute: 15
                     },
                     weekday: 2
                   }
                 },
                 %ControlPlus.Activity{
                   max_capacity: nil,
                   count: nil,
                   date: nil,
                   description: nil,
                   description_long: nil,
                   end_time: nil,
                   image: nil,
                   price: nil,
                   staff_id: nil,
                   staff_name: nil,
                   start: nil,
                   starts_at: nil,
                   status: nil,
                   sub_type_id: 0,
                   end_date: %Date{
                     calendar: Calendar.ISO,
                     day: 5,
                     month: 6,
                     year: 2017
                   },
                   activity_definition_id: 17916,
                   name: "MURPH special",
                   schedule: %ControlPlus.Schedule{
                     available: nil,
                     waitlist_size: nil,
                     start: %Time{
                       calendar: Calendar.ISO,
                       microsecond: {0, 0},
                       second: 0,
                       hour: 9,
                       minute: 0
                     },
                     weekday: 1
                   },
                   starts_on: %Date{
                     calendar: Calendar.ISO,
                     year: 2017,
                     day: 5,
                     month: 6
                   }
                 }
               ]
             } == ControlPlus.activities()
    end
  end

  test "member_visits_for_sync" do
    use_cassette "member_visits" do
      {
        :ok,

        [
          %ControlPlus.Activity{
            count: 1,
            date: ~D[2017-05-08],
            end_date: nil,
            activity_definition_id: 16443,
            name: "PowerBuilding Deadlift",
            price: nil,
            schedule: nil,
            start: ~T[19:00:00],
            starts_on: nil,
            status: 0,
            sub_type_id: nil
          },
          %ControlPlus.Activity{
            count: 1,
            date: ~D[2017-08-17],
            end_date: nil,
            activity_definition_id: 18345,
            name: "PowerBuilding Bench",
            price: nil,
            schedule: nil,
            start: ~T[19:00:00],
            starts_on: nil,
            status: 0,
            sub_type_id: nil
          }
        ]

      } = ControlPlus.member_visits(1016503)
    end
  end

  test "activity details" do
    use_cassette "activity_details" do
      assert {
               :ok,
               [
                 %ControlPlus.Activity{
                   count: nil,
                   date: nil,
                   description_long: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\n\n</body>\n</html>",
                   end_date: nil,
                   price: nil,
                   staff_id: nil,
                   staff_name: nil,
                   start: nil,
                   starts_on: nil,
                   status: nil,
                   sub_type_id: nil,
                   max_capacity: 12,
                   description: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\nlevel 1\n</body>\n</html>",
                   end_time: %Time{
                     calendar: Calendar.ISO,
                     microsecond: {0, 0},
                     second: 0,
                     hour: 20,
                     minute: 0
                   },
                   activity_definition_id: 18575,
                   image: "/uploads/27/88/24/13/app_bg_bench.jpg",
                   name: "PowerBuilding Bench",
                   schedule: %ControlPlus.Schedule{
                     waitlist_size: 0,
                     weekday: nil,
                     available: 4,
                     start: %Time{
                       calendar: Calendar.ISO,
                       microsecond: {0, 0},
                       second: 0,
                       hour: 19,
                       minute: 0
                     }
                   },
                   starts_at: %Time{
                     calendar: Calendar.ISO,
                     microsecond: {0, 0},
                     second: 0,
                     hour: 19,
                     minute: 0
                   }
                 },
                 %ControlPlus.Activity{
                   count: nil,
                   date: nil,
                   description_long: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\n\n</body>\n</html>",
                   end_date: nil,
                   price: nil,
                   staff_id: nil,
                   staff_name: nil,
                   start: nil,
                   starts_on: nil,
                   status: nil,
                   sub_type_id: nil,
                   max_capacity: 24,
                   description: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\nLevel 1\n</body>\n</html>",
                   end_time: %Time{
                     calendar: Calendar.ISO,
                     microsecond: {0, 0},
                     second: 0,
                     hour: 18,
                     minute: 15
                   },
                   activity_definition_id: 16343,
                   image: "/uploads/27/35/85/86/metcon-800x450.jpg",
                   name: "MetCon30",
                   schedule: %ControlPlus.Schedule{
                     waitlist_size: 0,
                     weekday: nil,
                     available: 2,
                     start: %Time{
                       calendar: Calendar.ISO,
                       microsecond: {0, 0},
                       second: 0,
                       hour: 17,
                       minute: 45
                     }
                   },
                   starts_at: %Time{
                     calendar: Calendar.ISO,
                     microsecond: {0, 0},
                     second: 0,
                     hour: 17,
                     minute: 45
                   }
                 }
               ]
             } == ControlPlus.activity_details()
    end
  end

  test "it can get reservations" do
    use_cassette "get_reservations" do
      date_time = DateTime.from_naive!(~N[2017-11-23 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               [
                 %ControlPlus.Reservation{id: 2758360, user_id: 1251776},
                 %ControlPlus.Reservation{id: 2759008, user_id: 1247568},
                 %ControlPlus.Reservation{id: 2759608, user_id: 1215297},
                 %ControlPlus.Reservation{id: 2761606, user_id: 1243171},
                 %ControlPlus.Reservation{id: 2762629, user_id: 1239420},
                 %ControlPlus.Reservation{id: 2763348, user_id: 1245300},
                 %ControlPlus.Reservation{id: 2767447, user_id: 1211655},
                 %ControlPlus.Reservation{id: 2768876, user_id: 1233832}
               ]
             } == ControlPlus.reservations(18575, date_time)
    end
  end

  test "it can get a waitlist" do
    use_cassette "wait_list" do
      date_time = DateTime.from_naive!(~N[2017-11-23 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               %ControlPlus.WaitList{
                 activity_title: "PowerBuilding Bench",
                 end_time: ~T[20:00:00],
                 waitlist: %{}
               }
             } == ControlPlus.wait_list(18575, date_time)
    end
  end

  test "it can handle corrupted json" do
    use_cassette "corrupted" do
      assert {:error, {:invalid, "0", 9}} == ControlPlus.wait_list(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.reservations(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.activity_details()
      assert {:error, {:invalid, "0", 9}} == ControlPlus.member_visits(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.client_details(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.activities()
      assert {:error, {:invalid, "0", 9}} == ControlPlus.paginated_clients()
    end
  end

  test "it can create a client" do
    use_cassette "create_client" do
      client = %ControlPlus.Client{
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
        sex: "F",
        zipcode: "1111AB",
      }
      assert  {
                :ok,
                %{
                  client_id: 1282833,
                  client_number: 904,
                  json_code: 29,
                  password: "test123",
                  username: "jane@doe.com"
                }
              } == ControlPlus.create_client(client)
    end
  end

  test "it can handle a reservation" do
    use_cassette "make_reservation" do
      date_time = DateTime.from_naive!(~N[2017-12-07 17:30:00.000], "Etc/UTC")
      assert {:ok, %{"json_code" => "4"}} == ControlPlus.make_reservation(996388, 18847, date_time)
    end
  end

  test "it can handle a reservation failure" do
    use_cassette "make_reservation failure" do
      date_time = DateTime.from_naive!(~N[2018-02-08 17:30:00.000], "Etc/UTC")
      assert {:error, "No membership linked"} == ControlPlus.make_reservation(996388, 18847, date_time)
    end
  end

  test "it can a cancel reservation" do
    date_time = DateTime.from_naive!(~N[2017-12-07 17:30:00.000], "Etc/UTC")
    use_cassette "cancel_reservation" do
      assert {:ok, %{"json_code" => "4"}} == ControlPlus.cancel_reservation(996388, 18847, date_time)
    end
  end

  test "it can handle a cancel reservation failure" do
    date_time = DateTime.from_naive!(~N[2018-02-08 17:30:00.000], "Etc/UTC")
    use_cassette "cancel_reservation_failure" do
      assert {:error, "Reservation not available"} == ControlPlus.cancel_reservation(996388, 18847, date_time)
    end
  end
end
