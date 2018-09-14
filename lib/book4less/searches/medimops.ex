defmodule Book4Less.Searches.Medimops do
  alias Book4Less.Searches.Query
  alias Book4Less.Books.Book

  @base_url "https://www.medimops.de/buecher-C0186606/?fcIsSearch=1&"

  def search_books(query = %Query{title: title} \\ %Query{title: "Elixir"}) do
    query
    |> build_url()
    |> execute_request()
    |> validate_response!()
    |> extract_books()
  end

  def build_url(query) do
    @base_url
    |> Kernel.<>(build_query_string(query))
  end

  defp build_query_string(%Query{title: title}) do
    %{searchparam: title}
    |> URI.encode_query()
  end

  defp execute_request(url) do
    HTTPoison.get(url)
  end

  defp validate_response!(resp) do
    case resp do
      {:ok, %{status_code: 200, body: body}} ->
        body

      {:ok, %{status_code: 404, body: _body}} ->
        "404"

      {:error, %{reason: reason}} ->
        "Error: #{reason}"
    end
  end

  defp extract_books(html) do
    html
    |> Floki.find(".mx-product-list-item")
    |> Enum.map(&extract_book(&1))
  end

  defp extract_book(elem) do
    {_, book} =
      {elem, %Book{}}
      |> extract_title()
      |> extract_img()
      |> extract_link()
      |> extract_price()
      |> extract_author()
      |> extract_state()

    book
  end

  defp extract_link({elem, book = %Book{}}) do
    link =
      elem
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> List.first()

    {elem, Map.put(book, :link, link)}
  end

  defp extract_img({elem, book = %Book{}}) do
    img =
      Floki.find(elem, "img")
      |> Floki.attribute("src")
      |> List.first()
      |> String.replace("-small.jpg", "-large.jpg")

    {elem, Map.put(book, :img_url, img)}
  end

  defp extract_title({elem, book = %Book{}}) do
    title =
      Floki.find(elem, "img")
      |> Floki.attribute("alt")
      |> List.first()

    {elem, Map.put(book, :title, title)}
  end

  defp extract_price({elem, book = %Book{}}) do
    price =
      elem
      |> Floki.find(".mx-product-list-item-price")
      |> Floki.text()

    {elem, Map.put(book, :price, price)}
  end

  defp extract_author({elem, book = %Book{}}) do
    author =
      elem
      |> Floki.find(".mx-product-list-item-manufacturer a")
      |> Floki.attribute("data-ga-label")
      |> List.first()

    {elem, Map.put(book, :author, author)}
  end

  defp extract_state({elem, book = %Book{}}) do
    state =
      elem
      |> Floki.find(".mx-product-list-item-condition")
      |> Floki.attribute("title")
      |> List.first()

    {elem, Map.put(book, :state, state)}
  end
end
