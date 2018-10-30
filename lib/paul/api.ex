defmodule Paul.Api.Base do
  use HTTPoison.Base

  @url "https://m.baristapaulbassett.co.kr"

  def url, do: @url

  def process_url(path) do
    @url <> path
  end

  def process_request_headers(headers) do
    Enum.into(headers, ["Content-Type": "application/x-www-form-urlencoded"])
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end
end
