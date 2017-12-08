defmodule ControlPlus.Api do
  @moduledoc """
  This module wraps the API of Control Plus.
  """

  @doc "Returns all the details of a client"
  @spec client_details(non_neg_integer) :: {:ok, %ControlPlus.Client{}} | {:error, any}
  def client_details(client_id) do
    result = ControlPlus.ApiClient.fetch(
      :client_detail,
      params: [
        client_id: client_id
      ]
    )
    case result do
      {:ok, data} -> {:ok, ControlPlus.Client.parse({client_id, data})}
      error -> error
    end
  end

  @doc "Returns a paginated list of clients"
  @spec paginated_clients(keyword | nil) ::
          {:ok, %{total_pages: non_neg_integer, current_page: non_neg_integer, clients: [%ControlPlus.Client{}]}} |
          {:error, any}
  def paginated_clients(options \\ [page: 1, limit: 30]) do
    case ControlPlus.ApiClient.fetch(:clients_list, params: [page: options[:page], limit: options[:limit]]) do
      {:ok, data} -> remap_users(data)
      error -> error
    end
  end

  @doc "returns a list of activities for a member. when no from and to are given, it defaults to the last year."
  @spec member_visits(non_neg_integer, Date.t | nil, Date.t | nil) :: {:ok, [%ControlPlus.Activity{}]} | {:error, any}
  def member_visits(client_id, from \\ nil, to \\ nil) do
    to = to || Date.utc_today()
    from = from || ControlPlus.Helpers.DateHelper.format_date_days_ago(365)
    case ControlPlus.ApiClient.fetch(
           :req_current_reservations,
           params: [
             client_id: client_id,
             start_date: from,
             end_date: ControlPlus.Helpers.DateHelper.format_date(to)
           ]
         ) do
      {:ok, data} -> remap_activities(data)
      error -> error
    end
  end

  @doc "returns a list of activity for a given date, or otherwise today"
  @spec activities(Date.t | nil) :: {:ok, [%ControlPlus.Activity{}]} | {:error, any}
  def activities(date \\ nil) do
    date = date || Date.utc_today()
    case ControlPlus.ApiClient.fetch(:req_activity_group_details, params: [date: ControlPlus.Helpers.DateHelper.format_date(date)]) do
      {:ok, data} -> remap_activities(data, date)
      error -> error
    end
  end

  @doc "returns reservations for a given activity and date, if no date given it uses today"
  @spec reservations(non_neg_integer, Date.t | nil) :: {:ok, [%ControlPlus.Reservation{}]} | {:error, any}
  def reservations(activity_id, date_time \\ nil) do

    date_time = date_time || DateTime.utc_now
    formatted_date_time = ControlPlus.Helpers.DateHelper.format_date_time(date_time)
    #TODO maybe convert UTC to Europe/Amsterdam
    case ControlPlus.ApiClient.fetch(
           :get_reservations,
           params: [
             date_time: formatted_date_time,
             activity_id: activity_id
           ]
         ) do
      {:ok, data} -> remap_reservations(data)
      error -> error
    end
  end

  @doc "returns a waiting list for a given activity and date, if no date given it uses today"
  @spec wait_list(non_neg_integer, Date.t | nil) :: {:ok, %ControlPlus.WaitList{}} | {:error, any}
  def wait_list(activity_id, date_time \\ nil) do

    date_time = date_time || DateTime.utc_now
    formatted_date_time = ControlPlus.Helpers.DateHelper.format_date_time(date_time)
    case ControlPlus.ApiClient.fetch(
           :get_waitlist,
           params: [
             date_time: formatted_date_time,
             activity_id: activity_id
           ]
         ) do
      {:ok, data} -> remap_wait_list(data)
      error -> error
    end
  end


  def create_client(%ControlPlus.Client{} = client) do
    case ControlPlus.ApiClient.fetch(:req_add_new_prospect, params: ControlPlus.Client.to_post_params(client)) do
      {:ok, result} -> {:ok, ControlPlus.Helpers.CastHelper.string_map_to_casted_atom(result)}
    end
  end

  def make_reservation(client_id, activity_id, date_time) do
    ControlPlus.ApiClient.fetch(
      :req_reservation,
      params: [
        client_id: client_id,
        activity_id: activity_id,
        date_time: ControlPlus.Helpers.DateHelper.format_date_time_for_api(date_time)
      ]
    )
  end

  def cancel_reservation(client_id, activity_id, date_time) do
    ControlPlus.ApiClient.fetch(
      :req_cancel,
      params: [
        client_id: client_id,
        activity_id: activity_id,
        date_time: ControlPlus.Helpers.DateHelper.format_date_time_for_api(date_time, :reversed)
      ]
    )
  end

  @spec remap_users(map) :: {:ok, map}
  defp remap_users(data) do
    map = %{}
          |> Map.put(:clients, Enum.map(data["users"], &ControlPlus.Client.parse/1))
          |> Map.put(:total_pages, String.to_integer(data["total_pages"]))
          |> Map.put(:current_page, String.to_integer(data["current_page"]))

    {:ok, map}
  end

  @spec remap_activities(map, Date.t | nil) :: {:ok, [%ControlPlus.Activity{}]}
  defp remap_activities(data, date \\ nil)
  defp remap_activities(%{"activities" => activities}, date) do
    result = Enum.map(activities, &ControlPlus.Activity.parse(&1, date))
    {:ok, result}
  end
  defp remap_activities(%{"shedule" => activities}, date) do
    result = Enum.map(activities, &ControlPlus.Activity.parse(&1, date))
    {:ok, result}
  end

  @spec remap_reservations(map) :: {:ok, [%ControlPlus.Reservation{}]}
  defp remap_reservations(data) do
    result = data
             |> Map.get("reservations", %{})
             |> Enum.map(&ControlPlus.Reservation.parse/1)

    {:ok, result}
  end

  @spec remap_wait_list(map) :: {:ok, map}
  defp remap_wait_list(data), do: {:ok, ControlPlus.WaitList.parse(data)}
end
