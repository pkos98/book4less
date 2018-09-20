defmodule Book4LessWeb.PageController do
  use Book4LessWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
