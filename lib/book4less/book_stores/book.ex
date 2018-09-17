defmodule Book4Less.Books.Book do
  defstruct [
    :title,
    :link,
    :img_url,
    :author,
    :price,
    :condition
  ]

  def put_book(value, key, book), do:  Map.update(book, key, value, fn(_x) -> value end)
end
