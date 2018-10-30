defmodule PaulWeb.PageView do
  use PaulWeb, :view

  def cards(conn) do
    conn.assigns[:cards]
  end
end
