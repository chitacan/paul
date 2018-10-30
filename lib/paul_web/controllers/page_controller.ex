defmodule PaulWeb.PageController do
  use PaulWeb, :controller

  alias Paul.Api

  def index(conn, _params) do
    id = System.get_env("ID") || raise "expected the ID env variable to be set"
    pw = System.get_env("PW") || raise "expected the PW env variable to be set"
    login = Api.login(id, pw)
    cards = Api.get_cards(login)
    render conn, "index.html", cards: cards
  end
end
