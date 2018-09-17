defmodule Book4Less.Searches.Search do
  defstruct [
    :query,
    :result,
    :book_store
  ]

  def put_search(value, key, search), do: Map.update(search, key, value, fn(_x) -> value end)
end
