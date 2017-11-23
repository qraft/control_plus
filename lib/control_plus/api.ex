defmodule ControlPlus.Api do
  @moduledoc """
  This module wraps the API endpoint of Control Plus.
  """

  use Tesla

  adapter :hackney, [ssl_options: [{:versions, [:'tlsv1.2']}]]
  plug Tesla.Middleware.BaseUrl,
       "https://#{Application.get_env(:control_plus, :client_name)}.opencontrolplus.com"

  @spec client_details(non_neg_integer) :: {:ok | map} | {:error, any}
  def client_details(client_id) do
    result = fetch(
      :client_detail,
      params: [
        client_id: client_id
      ]
    )

    case result do
      {:ok, data} -> {:ok, ControlPlus.User.parse({client_id, data})}
      error -> error
    end
  end

  @spec clients(non_neg_integer | nil, non_neg_integer | nil) :: {:ok, map} | {:error, any}
  def clients(page \\ 1, _limit \\ 30) do
    case fetch(:clients_list, page: page, limit: 1000) do
      {:ok, data} -> remap_users(data)
      error -> error
    end
  end

  @spec activities :: {:ok, map} | {:error, any}
  def activities do
    case fetch(:req_act_shedule, sub_type_id: "") do
      {:ok, data} -> remap_schedules(data)
      error -> error
    end
  end

  @spec member_visits(non_neg_integer, Date.t | nil, Date.t | nil) :: {:ok | map} | {:error, any}
  def member_visits(client_id, from \\ nil, to \\ nil) do
    to = to || ControlPlus.Helpers.DateHelper.format_date(Timex.today)
    from = from || ControlPlus.Helpers.DateHelper.format_date_days_ago(365)
    case fetch(:req_current_reservations, params: [client_id: client_id, start_date: from, end_date: to]) do
      {:ok, data} -> remap_activities(data)
      error -> error
    end
  end

  @spec activity_details(Date.t | nil) :: {:ok | map} | {:error, any}
  def activity_details(date \\ nil) do
    date = date || ControlPlus.Helpers.DateHelper.format_date(Timex.today)
    case fetch(:req_activity_group_details, date: date) do
      {:ok, data} -> remap_activities(data)
      error -> error
    end
  end

  @spec reservations(Date.t, non_neg_integer) :: {:ok | map} | {:error, any}
  def reservations(date_time, activity_id) do
    fetch(:get_reservations, date_time: date_time, activity_id: activity_id)
  end

  @spec waitlist(DateTime.t, non_neg_integer) :: {:ok | map} | {:error, any}
  def waitlist(date_time, activity_id) do
    fetch(:get_waitlist, date_time: date_time, activity_id: activity_id)
  end

  @spec fetch(atom, list) :: {:ok, map} | {:error, any}
  defp fetch(method, query) do
    defaults = [key: Application.get_env(:control_plus, :api_key), method: Atom.to_string(method)]
    query_with_defaults = Keyword.merge(query, defaults)
    IO.puts "query : #{inspect query_with_defaults}"
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
          |> Map.put(:users, Enum.map(data["users"], &ControlPlus.User.parse/1))
          |> Map.put(:total_pages, String.to_integer(data["total_pages"]))
          |> Map.put(:current_page, String.to_integer(data["current_page"]))

    {:ok, map}
  end

  @spec remap_activities(map) :: {:ok, map}
  defp remap_activities(data) do
    result = data["activities"] |> Enum.into(%{}, &ControlPlus.Activity.parse/1)

    map = Map.put(%{}, :activities, result)

    {:ok, map}
  end

  @spec remap_schedules(map) :: {:ok, map}
  defp remap_schedules(data) do
    result = data["shedule"] |> Enum.into(%{}, &ControlPlus.Activity.parse/1)

    map = Map.put(%{}, :schedule, result)

    {:ok, map}
  end
end
