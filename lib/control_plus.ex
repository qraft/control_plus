defmodule ControlPlus do
  @moduledoc """
  ControlPlus is a CRM system. This package wraps the api of that
  """

  defdelegate activities(), to: ControlPlus.Api
  defdelegate client_details(id), to: ControlPlus.Api
  defdelegate member_visits(client_id, from \\ nil, to \\ nil), to: ControlPlus.Api
  defdelegate paginated_clients(options \\ nil), to: ControlPlus.Api
  defdelegate activity_details(date \\ nil), to: ControlPlus.Api
  defdelegate wait_list(activity_id, date_time \\ nil), to: ControlPlus.Api
  defdelegate reservations(activity_id, date_time \\ nil), to: ControlPlus.Api
  defdelegate cancel_reservation(client_id, activity_id, date_time), to: ControlPlus.Api
  defdelegate make_reservation(client_id, activity_id, date_time), to: ControlPlus.Api
  defdelegate create_client(client), to: ControlPlus.Api
end
