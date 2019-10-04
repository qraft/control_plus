defmodule ControlPlus.ApiTest do

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixture/vcr_cassettes")
    :ok
  end

  test "should get a list of clients" do
    use_cassette "get_clients" do
      assert   {
                 :ok,
                 %{
                   clients: [
                     %ControlPlus.Client{
                       bank_account: nil,
                       birthdate: ~D[1984-06-09],
                       brought_by: nil,
                       campaign: nil,
                       city: "Den Haag",
                       club_card_amount: 0.0,
                       club_id: nil,
                       comment: "Aangemeld bij Demodag. Na telefonische intake afgesproken op de wachtlijst voor pilot 3 of 4 . Stopt per 1 aug. #06  heeft geen rede op gegeven.",
                       control_plus_id: 1014557,
                       country: "Netherlands",
                       email: "test@user.com",
                       entered: "Web-in",
                       gender: "F",
                       json_code: nil,
                       labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                       lastname: "Testuser2",
                       member_number: 45,
                       mobile_phone: "0612345678",
                       name: "Test",
                       password: nil,
                       personal_coach: nil,
                       phone: nil,
                       photo: nil,
                       prefix: nil,
                       province: nil,
                       sales: nil,
                       street: "Somewhere 123",
                       updated_at: %DateTime{},
                       zipcode: "2211GB",
                       subscriptions: []
                     },
                     %ControlPlus.Client{
                       bank_account: nil,
                       birthdate: ~D[1967-07-27],
                       brought_by: nil,
                       campaign: nil,
                       city: "Amsterdam",
                       club_card_amount: 0.0,
                       club_id: nil,
                       comment: "Just some comment here",
                       control_plus_id: 1016570,
                       country: "Netherlands",
                       email: "someone@gmail.com",
                       entered: "Web-in",
                       gender: "M",
                       json_code: nil,
                       labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                       lastname: "Testuser",
                       member_number: 24,
                       mobile_phone: "0612345678",
                       name: "Test",
                       password: nil,
                       personal_coach: nil,
                       phone: nil,
                       photo: nil,
                       prefix: "Van den",
                       province: nil,
                       sales: nil,
                       street: "Somestreet 1",
                       updated_at: %DateTime{},
                       zipcode: "1111AA",
                       subscriptions: subscriptions
                     }
                   ],
                   current_page: 1,
                   total_pages: 31
                 }
               } = ControlPlus.paginated_clients()

      assert 24 = subscriptions |> Enum.count()
      assert %ControlPlus.Subscription{
               end_date: ~D[2016-09-30],
               id: 3164644,
               last_visit: nil,
               max_visit: nil,
               start_date: ~D[2016-09-20],
               stop_date: nil,
               type: 3,
               type_id: 13401,
               type_name: "Semi Personal Training pilot",
               visit_done: nil
             } = subscriptions |> Enum.at(0)
    end
  end

  test "should return an error when trying to get a list of clients with an invalid status" do
    {
      :error,
      "invalid status something should be one of leads, leads_passive, leads_active, valid, not_valid, not_valid_recent, future, old, not_active, active, in_stop, in_medical_stop"
    } = ControlPlus.paginated_clients_with_status(:something)
  end

  test "should get a list of clients with a certain status" do
    use_cassette "get_clients_with_status" do
      assert   {
                 :ok,
                 %{
                   clients: [
                     %ControlPlus.Client{
                       bank_account: nil,
                       birthdate: ~D[1984-06-09],
                       brought_by: nil,
                       campaign: nil,
                       city: "Den Haag",
                       club_card_amount: 0.0,
                       club_id: nil,
                       comment: "Aangemeld bij Demodag. Na telefonische intake afgesproken op de wachtlijst voor pilot 3 of 4 . Stopt per 1 aug. #06  heeft geen rede op gegeven.",
                       control_plus_id: 1014557,
                       country: "Netherlands",
                       email: "test@user.com",
                       entered: "Web-in",
                       gender: "F",
                       json_code: nil,
                       labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                       lastname: "Testuser2",
                       member_number: 45,
                       mobile_phone: "0612345678",
                       name: "Test",
                       password: nil,
                       personal_coach: nil,
                       phone: nil,
                       photo: nil,
                       prefix: nil,
                       province: nil,
                       sales: nil,
                       street: "Somewhere 123",
                       updated_at: %DateTime{},
                       zipcode: "2211GB"

                     },
                     %ControlPlus.Client{
                       bank_account: nil,
                       birthdate: ~D[1967-07-27],
                       brought_by: nil,
                       campaign: nil,
                       city: "Amsterdam",
                       club_card_amount: 0.0,
                       club_id: nil,
                       comment: "Just some comment here",
                       control_plus_id: 1016570,
                       country: "Netherlands",
                       email: "someone@gmail.com",
                       entered: "Web-in",
                       gender: "M",
                       json_code: nil,
                       labels: "Afvallers /niet geselecteerd/ in de toekomst contacten",
                       lastname: "Testuser",
                       member_number: 24,
                       mobile_phone: "0612345678",
                       name: "Test",
                       password: nil,
                       personal_coach: nil,
                       phone: nil,
                       photo: nil,
                       prefix: "Van den",
                       province: nil,
                       sales: nil,
                       street: "Somestreet 1",
                       updated_at: %DateTime{},
                       zipcode: "1111AA"
                     }
                   ],
                   current_page: 1,
                   total_pages: 31
                 }
               } = ControlPlus.paginated_clients_with_status(:active)
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
                 bank_account: nil,
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
                 control_plus_id: 1017831,
                 prefix: nil,
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
                 street: "Somestreet 1",
                 gender: "F",
                 subscriptions: [],
                 updated_at: nil,
                 zipcode: "1111AB",
               }
             } = ControlPlus.client_details(1017831)
    end
  end

  #  test "should get a list of activities" do
  #    use_cassette "get_activities" do
  #      assert  {
  #                :ok,
  #                [
  #                  %{
  #                    __struct__: ControlPlus.Activity,
  #                    control_plus_id: 16939,
  #                    count: nil,
  #                    date: nil,
  #                    description: nil,
  #                    description_long: nil,
  #                    duration_in_minutes: -1,
  #                    end_date: ~D[2019-03-17],
  #                    end_time: nil,
  #                    ends_at: %DateTime{},
  #                    image: nil,
  #                    max_capacity: nil,
  #                    name: "Your personal coach",
  #                    price: nil,
  #                    staff_id: nil,
  #                    staff_name: nil,
  #                    start: nil,
  #                    start_date: ~D[2017-02-27],
  #                    start_time: nil,
  #                    starts_at: %DateTime{},
  #                    status: nil,
  #                    sub_type_id: 0
  #                  },
  #                  %{
  #                    __struct__: ControlPlus.Activity,
  #                    control_plus_id: 18337,
  #                    count: nil,
  #                    date: nil,
  #                    description: nil,
  #                    description_long: nil,
  #                    duration_in_minutes: -1,
  #                    end_date: ~D[2023-03-17],
  #                    end_time: nil,
  #                    ends_at: %DateTime{},
  #                    image: nil,
  #                    max_capacity: nil,
  #                    name: "Your personal coach",
  #                    price: nil,
  #                    staff_id: nil,
  #                    staff_name: nil,
  #                    start: nil,
  #                    start_date: ~D[2017-02-27],
  #                    start_time: nil,
  #                    starts_at: %DateTime{},
  #                    status: nil,
  #                    sub_type_id: 0
  #                  },
  #                  %{
  #                    __struct__: ControlPlus.Activity,
  #                    control_plus_id: 17916,
  #                    count: nil,
  #                    date: nil,
  #                    description: nil,
  #                    description_long: nil,
  #                    duration_in_minutes: -1,
  #                    end_date: ~D[2017-06-05],
  #                    end_time: nil,
  #                    ends_at: %DateTime{},
  #                    image: nil,
  #                    max_capacity: nil,
  #                    name: "MURPH special",
  #                    price: nil,
  #                    staff_id: nil,
  #                    staff_name: nil,
  #                    start: nil,
  #                    start_date: ~D[2017-06-05],
  #                    start_time: nil,
  #                    starts_at: %DateTime{},
  #                    status: nil,
  #                    sub_type_id: 0
  #                  }
  #                ]
  #              } = ControlPlus.activities()
  #    end
  #  end

  test "member_visits_for_sync" do
    use_cassette "member_visits" do
      {
        :ok,

        [
          %ControlPlus.Activity{
            count: 1,
            date: ~D[2017-05-08],
            duration_in_minutes: nil,
            end_date: nil,
            control_plus_id: 16443,
            name: "PowerBuilding Deadlift",
            price: nil,
            start: ~T[19:00:00],
            start_date: nil,
            status: 0,
            sub_type_id: nil
          },
          %ControlPlus.Activity{
            count: 1,
            date: ~D[2017-08-17],
            duration_in_minutes: nil,
            end_date: nil,
            control_plus_id: 18345,
            name: "PowerBuilding Bench",
            price: nil,
            start: ~T[19:00:00],
            start_date: nil,
            status: 0,
            sub_type_id: nil
          }
        ]

      } = ControlPlus.member_visits(1016503)
    end
  end

  test "activity details" do
    use_cassette "activity_details" do
      assert  {
                :ok,
                [
                  %{
                    __struct__: ControlPlus.Activity,
                    control_plus_id: 18575,
                    count: nil,
                    date: nil,
                    description: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\nlevel 1\n</body>\n</html>",
                    description_long: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\n\n</body>\n</html>",
                    duration_in_minutes: 60,
                    end_date: nil,
                    end_time: ~T[20:00:00],
                    ends_at: %DateTime{},
                    image: "/uploads/27/88/24/13/app_bg_bench.jpg",
                    max_capacity: 12,
                    name: "PowerBuilding Bench",
                    price: nil,
                    staff_id: nil,
                    staff_name: nil,
                    start: nil,
                    start_date: nil,
                    start_time: ~T[19:00:00],
                    starts_at: %DateTime{},
                    status: nil,
                    sub_type_id: nil
                  },
                  %{
                    __struct__: ControlPlus.Activity,
                    control_plus_id: 16343,
                    count: nil,
                    date: nil,
                    description: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\nLevel 1\n</body>\n</html>",
                    description_long: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head>\n</head>\n<body>\n\n</body>\n</html>",
                    duration_in_minutes: 30,
                    end_date: nil,
                    end_time: ~T[18:15:00],
                    ends_at: %DateTime{},
                    image: "/uploads/27/35/85/86/metcon-800x450.jpg",
                    max_capacity: 24,
                    name: "MetCon30",
                    price: nil,
                    staff_id: nil,
                    staff_name: nil,
                    start: nil,
                    start_date: nil,
                    start_time: ~T[17:45:00],
                    starts_at: %DateTime{},
                    status: nil,
                    sub_type_id: nil
                  }
                ]
              } = ControlPlus.activities()

    end
  end

  test "it can get reservations" do
    use_cassette "get_reservations" do
      date_time = DateTime.from_naive!(~N[2017-11-23 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               [
                 %ControlPlus.Reservation{id: 2758360, control_plus_user_id: 1251776},
                 %ControlPlus.Reservation{id: 2759008, control_plus_user_id: 1247568},
                 %ControlPlus.Reservation{id: 2759608, control_plus_user_id: 1215297},
                 %ControlPlus.Reservation{id: 2761606, control_plus_user_id: 1243171},
                 %ControlPlus.Reservation{id: 2762629, control_plus_user_id: 1239420},
                 %ControlPlus.Reservation{id: 2763348, control_plus_user_id: 1245300},
                 %ControlPlus.Reservation{id: 2767447, control_plus_user_id: 1211655},
                 %ControlPlus.Reservation{id: 2768876, control_plus_user_id: 1233832}
               ]
             } == ControlPlus.reservations(18575, date_time)
    end
  end

  test "it can get a waitlist" do
    use_cassette "wait_list_empty" do
      date_time = DateTime.from_naive!(~N[2017-12-05 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               %ControlPlus.WaitList{
                 activity_title: "PowerBuilding Bench",
                 end_time: ~T[20:00:00],
                 waitlist: []
               }
             } == ControlPlus.wait_list(18574, date_time)
    end

    use_cassette "wait_list_filled" do
      date_time = DateTime.from_naive!(~N[2017-12-04 19:00:00.000], "Etc/UTC")

      assert {
               :ok,
               %ControlPlus.WaitList{
                 activity_title: "PowerBuilding Deadlift",
                 end_time: ~T[20:00:00],
                 waitlist: [1215309, 996388]
               }
             } == ControlPlus.wait_list(18574, date_time)
    end
  end

  test "it can handle corrupted json" do
    use_cassette "corrupted" do
      assert {:error, {:invalid, "0", 9}} == ControlPlus.wait_list(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.reservations(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.member_visits(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.client_details(-1)
      assert {:error, {:invalid, "0", 9}} == ControlPlus.activities()
      assert {:error, {:invalid, "0", 9}} == ControlPlus.paginated_clients()
    end
  end

  test "it can create a client" do
    use_cassette "create_client" do
      client = %ControlPlus.Client{
        street: "Somestreet 1",
        bank_account: "NL08INGB0123456789",
        birthdate: ~D[1981-06-24],
        city: "Utrecht",
        comment: "Afvallers /niet geselecteerd/ in de toekomst contacten",
        country: "Netherlands",
        email: "jane@doe.com",
        prefix: 12345,
        lastname: "Doe",
        mobile_phone: "0612345678",
        name: "Jane",
        password: "test123",
        gender: "F",
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
