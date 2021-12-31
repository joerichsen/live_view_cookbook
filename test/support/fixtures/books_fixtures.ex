defmodule Cookbook.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cookbook.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        pages: 42,
        summary: "some summary",
        title: "some title"
      })
      |> Cookbook.Books.create_book()

    book
  end
end
