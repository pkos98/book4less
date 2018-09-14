defmodule Book4lessWeb.PageController do
  use Book4lessWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
