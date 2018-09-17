defmodule Book4Less.Searches.Medimops do
  use Book4Less.BookStores.BookStore, :book_store

  @moduledoc """
  Book-Store implementation for medimops.de.
  Implemented query-options:
    * title
  Other query-options will simply be ignored.
  """

  @base_url "https://www.medimops.de/buecher-C0186606/?fcIsSearch=1&"

  @impl true
  def search_books(query = %Query{} \\ %Query{title: "Der Mann"}) do
    try do
      query
      |> build_url()
      |> execute_request()
      |> validate_response!()
      |> extract_books(%Search{query: query, book_store: Medimops})
    catch
      value -> value
    end
  end

  defp build_url(%Query{title: title}) do
    %{searchparam: title}
    |> URI.encode_query()
    |> (fn query_string -> @base_url <> query_string end).()
  end

  defp execute_request(url) do
    url
    |> HTTPoison.get()
  end

  defp validate_response!(response) do
    case response do
      {:ok, %{status_code: 200, body: body}} ->
        body

      {:ok, %{status_code: 404, body: _body}} ->
        raise "404"

      {:error, %{reason: reason}} ->
        "Error: #{reason}"
    end
  end

  @spec extract_books(String.t, %Search{}) :: %Search{}
  defp extract_books(html, search = %Search{}) do
    html
    |> Floki.find(".mx-product-list-item")
    |> Enum.map(&extract_book(&1))
    |> put_search(:result, search)
  end

  defp extract_book(book_elem) do
    %Book{}
    |> extract_title(book_elem)
    |> extract_author(book_elem)
    |> extract_img(book_elem)
    |> extract_link(book_elem)
    |> extract_price(book_elem)
    |> extract_condition(book_elem)
  end

  defp extract_link(book = %Book{}, elem) do
    elem
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> List.first()
    |> put_book(:link, book)
  end

  defp extract_img(book = %Book{}, elem) do
    elem
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> List.first()
    |> String.replace("-small.jpg", "-large.jpg")
    |> put_book(:img_url, book)
  end

  defp extract_title(book = %Book{}, elem) do
    elem
    |> Floki.find("img")
    |> Floki.attribute("alt")
    |> List.first()
    |> put_book(:title, book)
  end

  defp extract_price(book = %Book{}, elem) do
    elem
    |> Floki.find(".mx-product-list-item-price")
    |> Floki.text()
    |> put_book(:price, book)
  end

  defp extract_author(book = %Book{}, elem) do
    elem
    |> Floki.find(".mx-product-list-item-manufacturer a")
    |> Floki.attribute("data-ga-label")
    |> List.first()
    |> put_book(:author, book)
  end

  defp extract_condition(book = %Book{}, elem) do
    elem
    |> Floki.find(".mx-product-list-item-condition")
    |> Floki.attribute("title")
    |> List.first()
    |> put_book(:condition, book)
  end
end
