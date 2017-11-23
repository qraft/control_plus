defmodule ControlPlus.Api do
  @moduledoc """
  This module wraps the API endpoint of Control Plus.
  """

  use Tesla

  adapter :hackney, [ssl_options: [{:versions, [:'tlsv1.2']}]]
  plug Tesla.Middleware.BaseUrl,
       "https://#{Application.get_env(:control_plus, :client_name)}.opencontrolplus.com"

  @spec client_details(non_neg_integer) :: {:ok, %ControlPlus.Client{}} | {:error, any}
  def client_details(client_id) do
    result = fetch(
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

  @spec paginated_clients(non_neg_integer | nil, non_neg_integer | nil) ::
          {:ok, %{total_pages: non_neg_integer, current_page: non_neg_integer, clients: [%ControlPlus.Client{}]}} |
          {:error, any}
  def paginated_clients(page \\ 1, _limit \\ 30) do
    case fetch(:clients_list, page: page, limit: 1000) do
      {:ok, data} -> remap_users(data)
      error -> error
    end
  end

  @spec activities :: {:ok, [%ControlPlus.Activity{}]} | {:error, any}
  def activities do
    case fetch(:req_act_shedule, sub_type_id: "") do
      {:ok, data} -> remap_schedules(data)
      error -> error
    end
  end

  @spec member_visits(non_neg_integer, Date.t | nil, Date.t | nil) :: {:ok , [%ControlPlus.Activity{}]} | {:error, any}
  def member_visits(client_id, from \\ nil, to \\ nil) do
    to = to || ControlPlus.Helpers.DateHelper.format_date(Timex.today)
    from = from || ControlPlus.Helpers.DateHelper.format_date_days_ago(365)
    case fetch(
           :req_current_reservations,
           params: [
             client_id: client_id,
             start_date: from,
             end_date: to
           ]
         ) do
      {:ok, data} -> remap_activities(data)
      error -> error
    end
  end

  @spec activity_details(Date.t | nil) :: {:ok, [%ControlPlus.Activity{}]} | {:error, any}
  def activity_details(date \\ nil) do
    date = date || ControlPlus.Helpers.DateHelper.format_date(Timex.today)
    case fetch(:req_activity_group_details, date: date) do
      {:ok, data} -> remap_activities(data)
      error -> error
    end
  end

  @spec reservations(non_neg_integer, Date.t | nil) :: {:ok, [%ControlPlus.Reservation{}]} | {:error, any}
  def reservations(activity_id, date_time \\ nil) do

    date_time = date_time || DateTime.utc_now
    formatted_date_time = ControlPlus.Helpers.DateHelper.format_date_time(date_time)
    case fetch(
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

  @spec wait_list(non_neg_integer, Date.t | nil) :: {:ok, %ControlPlus.WaitList{}} | {:error, any}
  def wait_list(activity_id, date_time \\ nil) do

    date_time = date_time || DateTime.utc_now
    formatted_date_time = ControlPlus.Helpers.DateHelper.format_date_time(date_time)
    case fetch(
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

  @spec fetch(atom, list) :: {:ok, map} | {:error, any}
  defp fetch(method, query) do
    defaults = [key: Application.get_env(:control_plus, :api_key), method: Atom.to_string(method)]
    query_with_defaults = Keyword.merge(query, defaults)

    "/cp_api"
    |> get(query: query_with_defaults)
    |> handle_response
  end

  @spec handle_response(map) :: {:ok, map} | {:error, any}
  defp handle_response(%{status: 200, body: json}) do
    json
    |> Poison.decode
    |> handle_json
  end
  defp handle_response(%{status: status}), do: {:error, status}

  @spec handle_json({:ok, map} | {:error, any}) :: {:ok, map} | {:error, any}
  defp handle_json({:ok, %{"error" => "0", "result" => data}}), do: {:ok, data}
  defp handle_json({:ok, %{"error" => error_code}}), do: {:error, error_code}
  defp handle_json(error), do: error

  @spec remap_users(map) :: {:ok, map}
  defp remap_users(data) do
    map = %{}
          |> Map.put(:clients, Enum.map(data["users"], &ControlPlus.Client.parse/1))
          |> Map.put(:total_pages, String.to_integer(data["total_pages"]))
          |> Map.put(:current_page, String.to_integer(data["current_page"]))

    {:ok, map}
  end

  @spec remap_activities(map) :: {:ok, [%ControlPlus.Activity{}]}
  defp remap_activities(data) do
    result = Enum.map(data["activities"], &ControlPlus.Activity.parse/1)

    {:ok, result}
  end

  @spec remap_schedules(map) :: {:ok, [%ControlPlus.Activity{}]}
  defp remap_schedules(data) do
    result = Enum.map(data["shedule"], &ControlPlus.Activity.parse/1)
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
