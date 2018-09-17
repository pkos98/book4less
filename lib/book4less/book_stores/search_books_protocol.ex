defmodule Book4Less.Searches.SearchBookBehaviour do
  alias Book4Less.Searches.{Query, Search}

  @doc """
  Callback to be implemented in order to search books.
  Each BookStore has to implement this behaviour.
  """
  @callback search_books(%Query{}) :: %Search{}

end
