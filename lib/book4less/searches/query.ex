defmodule Book4less.Searches.Query do
  # for the schema macro
  use Ecto.Schema
  # for the changeset functions
  import Ecto.Changeset
  alias Book4less.Searches.Query

  @required_fields [:title]
  @permitted_fields [:title, :author, :country]
  @word_min_length 3

  schema "queries" do
    field(:title, :string)
    field(:author, :string)
    field(:country, :string, default: "de")

    timestamps()
  end

  def changeset(query = %Query{}, params \\ {}) do
    query
    |> cast(params, @permitted_fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, min: @word_min_length)
    |> validate_length(:country, is: 2)
  end

  def to_map(%Query{title: title, author: author, country: country}) do
    %{title: title, author: author, country: country}
  end
end
