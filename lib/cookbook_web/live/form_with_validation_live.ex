defmodule CookbookWeb.FormWithValidationLive do
  use CookbookWeb, :live_view

  alias Cookbook.Books
  alias Cookbook.Books.Book

  def render(assigns) do
    ~H"""
    <.form let={f} for={@changeset} phx-change="validate" phx-submit="save" novalidate>
      <div class="mb-3">
        <%= label(f, :title) %>
        <%= text_input(f, :title, class: "form-control", placeholder: "Enter title") %>
        <%= error_tag(f, :title) %>
      </div>

      <div class="mb-3">
        <%= label(f, :summary) %>
        <%= textarea(f, :summary, class: "form-control", placeholder: "Add a short summary") %>
        <%= error_tag(f, :summary) %>
      </div>

      <div class="mb-3">
        <%= label(f, :pages) %>
        <%= number_input(f, :pages, class: "form-control", placeholder: "Enter the number of pages") %>
        <%= error_tag(f, :pages) %>
      </div>

      <button type="submit" class="btn btn-primary btn-sm">Add Book</button>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{changeset: Books.change_book(%Book{})})}
  end

  def handle_event("validate", %{"book" => params}, socket) do
    changeset = %Book{} |> Books.change_book(params) |> Map.put(:action, :insert)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"book" => params}, socket) do
    case Books.create_book(params) do
      {:ok, _book} -> {:noreply, socket |> put_flash(:info, "Book Added")}
      {:error, %Ecto.Changeset{} = changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
