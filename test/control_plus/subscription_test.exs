defmodule ControlPlus.SubscriptionTest do
  use ExUnit.Case
  test "it can parse subscriptions" do
    params = %{
        inscr_visitdone: "",
        inscr_id: "3585380",
        inscr_maxvisit: "",
        inscrtype_type: "3",
        inscr_last_visit: "",
        inscr_startdate: "01/05/2017",
        inscrtype_id: "13401",
        inscr_stop_date: "",
        inscr_enddate: "31/05/2017",
        inscrtype_name: "Semi Personal Training pilot"
    }


    assert %ControlPlus.Subscription{} == ControlPlus.Subscription.parse(nil)
    assert %ControlPlus.Subscription{} == ControlPlus.Subscription.parse(%{})
    assert %ControlPlus.Subscription{
             id: 3585380,
             type: 3,
             type_id: 13401,
             type_name: "Semi Personal Training pilot",
             end_date: ~D[2017-05-31],
             start_date: ~D[2017-05-01],
             last_visit: nil,
             visit_done: nil
           } == ControlPlus.Subscription.parse(params)
  end
end
