defmodule Cookbook.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :pages, :integer
    field :summary, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :summary, :pages])
    |> validate_required([:title, :pages])
    |> validate_number(:pages, greater_than: 0)
    |> validate_number(:pages, less_than: 2000)
  end
end
