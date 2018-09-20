defmodule Book4LessWeb.SearchChannel do
  use Phoenix.Channel

  def join("search:"<>search_phrase, _auth_msg, socket) do
    IO.inspect search_phrase
    {:ok, socket}
  end

  def handle_in("search_input", %{"input" => search_input}, socket) do
    IO.puts "[+] Guessing suggestions for \"#{search_input}\"..."
    case request_suggestions(search_input) do
      {:ok, suggestion_list} ->
        broadcast(socket, "new_suggestions", suggestion_list)
    end
    {:noreply, socket}
  end

  def request_suggestions(text) do
    params = text
    case HTTPoison.get("https://www.rebuy.de/search-proxy/suggestion/de/outbound?q=" <> params) do
      {:ok, %{status_code: 200, body: body}} ->
        decode_json_suggestions(body)
      error = {:error, _reason} ->
        error
    end
  end

  defp decode_json_suggestions(encoded) do
    case Poison.decode(encoded) do
      {:ok, %{"response" => %{"docs" => docs}}} ->
        {:ok, %{suggestions: docs}}
      error = {:error, _reason} ->
        error
    end
  end

end
