defmodule Book4Less.BookStores.BookStore do
  def book_store do
    quote do
      alias Book4Less.Searches.{Query, Search}
      alias Book4Less.Books.Book
      alias Book4Less.Searches.SearchBookBehaviour
      import Search, only: [put_search: 3]
      import Book, only: [put_book: 3]
      @behaviour Book4Less.Searches.SearchBookBehaviour
      @user_agent [{"User-Agent", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36"}]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
