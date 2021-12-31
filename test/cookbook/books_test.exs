defmodule Cookbook.BooksTest do
  use Cookbook.DataCase

  alias Cookbook.Books

  describe "books" do
    alias Cookbook.Books.Book

    import Cookbook.BooksFixtures

    @invalid_attrs %{pages: nil, summary: nil, title: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Books.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{pages: 42, summary: "some summary", title: "some title"}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.pages == 42
      assert book.summary == "some summary"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{pages: 43, summary: "some updated summary", title: "some updated title"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.pages == 43
      assert book.summary == "some updated summary"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
      assert book == Books.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end
end
