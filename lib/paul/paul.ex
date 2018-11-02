defmodule Paul.Login do
  defstruct id: nil, email: nil, cookie: nil
end

defmodule Paul.Card do
  defstruct id: nil, amount: 0, img: nil
end

defmodule Paul.Api do
  alias Paul.Login
  alias Paul.Card
  alias Paul.Api.Base, as: Api

  def login(id, pw) do
    body =
      "PACKET_ID=01&DEVICE_TOKEN=blabla&OSKIND=2&PUSH_RCV_YN=N&CUST_ID=#{id}&CUST_PW=#{
        URI.encode_www_form(pw)
      }"

    case Api.post("/member.do", body) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        cookie =
          headers
          |> Enum.at(1)
          |> elem(1)
          |> String.split(";")
          |> Enum.at(0)

        %{"CUST_ID" => id, "EMAIL" => email} = body
        %Login{id: id, email: email, cookie: cookie}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "404 not found"

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def get_primary_card(%Login{id: id, cookie: cookie}) do
    body = "PACKET_ID=22&CUST_ID=#{id}"
    headers = [Cookie: cookie]

    case Api.post("/card.do", body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"CARD_ID" => id, "BALANCE_AMT" => amount} = body
        %Card{id: id, amount: String.to_integer(amount)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "404 not found"

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def get_cards(%Login{id: id, cookie: cookie}) do
    body = "PACKET_ID=14&CUST_ID=#{id}&PAGE_NO=1"
    headers = [Cookie: cookie]

    case Api.post("/card.do", body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Map.get("List")
        |> Enum.map(fn %{"cardId" => id, "imageUrl" => img, "balanceAmt" => amount} ->
          %Card{id: id, img: Api.url() <> img, amount: String.to_integer(amount)}
        end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "404 not found"

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end
end
