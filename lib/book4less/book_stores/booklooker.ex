defmodule Book4Less.BookStores.Booklooker do
  use Book4Less.BookStores.BookStore, :book_store

  @host "https://www.booklooker.de"
  @base_url @host<>"/Bücher/Angebote/"

  @impl true
  def search_books(query = %Query{} \\ %Query{title: "Elixir in"}) do
    query
    |> build_url()
    |> execute_request()
    |> validate_response!()
    |> extract_books(%Search{query: query, book_store: Rebuy})
  end

  def build_url(%Query{title: title}) do
    %{titel: title, lid: 3}
    |> URI.encode_query()
    |> (fn query_string -> @base_url <> query_string end).()
  end

  defp execute_request(url) do
    url
    |> HTTPoison.get(@user_agent)
  end

  defp validate_response!(response) do
    case response do
      {:ok, %{status_code: 200, body: html}} ->
        html
    end
  end

  defp extract_books(html, search = %Search{}) do
    File.write("/home/patrick/output.html", html)
    html
    |> Floki.find(".articleRow")
    |> Enum.map(&extract_book(&1))
    |> put_search(:result, search)
  end

  defp extract_book(html_elem) do
    %Book{}
    |> extract_title(html_elem)
    |> extract_link(html_elem)
    |> extract_img(html_elem)
    |> extract_author(html_elem)
    |> extract_price(html_elem)
    |> extract_condition(html_elem)
  end

  defp extract_title(book, html) do
    html
    |> Floki.find("td.resultlist_productsimage a img")
    |> Floki.attribute("title")
    |> List.first()
    |> put_book(:title, book)
  end

  defp extract_link(book, html) do
    html
    |> Floki.find("td.resultlist_productstatus a")
    |> Floki.attribute("href")
    |> List.first()
    |> (fn(x) -> @host<>x end).()
    |> put_book(:link, book)
  end

  defp extract_img(book, html) do
    html
    |> Floki.find("td.resultlist_productsimage a img")
    |> Floki.attribute("src")
    |> List.first()
    |> put_book(:img_url, book)
  end

  defp extract_author(book, _html), do: book

  defp extract_price(book, html) do
    html
    |> Floki.find(".price")
    |> Floki.text()
    |> put_book(:price, book)
  end

  defp extract_condition(book, html) do
    html
    |> Floki.find(".resultlist_productsimage")
    |> Floki.text()
    |> String.split("\n")
    |> Enum.take(-2)
    |> List.first()
    |> put_book(:condition, book)
  end

end
