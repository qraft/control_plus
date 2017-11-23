defmodule ControlPlus.ApiClient do
  @moduledoc """
  This module takes care of the actual connection to opencontrolplus and it's json api
  """

  use Tesla

  adapter :hackney, [ssl_options: [{:versions, [:'tlsv1.2']}]]
  plug Tesla.Middleware.BaseUrl,
       "https://#{Application.get_env(:control_plus, :client_name)}.opencontrolplus.com"

  @doc """
  A short hand method to fetch the data from the opencontrolplus api used by `ControlPlus.Api`
  """
  @spec fetch(atom, list) :: {:ok, map} | {:error, any}
  def fetch(method, query) do
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
end