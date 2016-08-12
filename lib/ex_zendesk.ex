defmodule ExZendesk do
  use HTTPoison.Base

  def process_url(url) do
    subdomain <> url
  end

  def process_response_body(body) do
    try do
      Poison.decode!(body, keys: :atoms)
    rescue
      _ -> body
    end
  end

  def process_request_headers(headers) do
    added_headers = [{"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"User-Agent", "Elixir/ExZendesk"},
      {"Authorization", "Basic " <> Base.encode64(user <> ":" <> password)}]
    headers ++ added_headers
  end

  def process_request_body(body) do
    Poison.encode! body
  end

  defp user do
    System.get_env("ZENDESK_USER") || Application.get_env(:ex_zendesk, :user)
  end

  defp password do
    System.get_env("ZENDESK_PASSWORD") || Application.get_env(:ex_zendesk, :password)
  end

  defp subdomain do
    System.get_env("ZENDESK_SUBDOMAIN") || Application.get_env(:ex_zendesk, :subdomain)
  end

end
