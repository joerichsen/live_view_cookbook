defmodule CookbookWeb.MarkdownPreviewLive do
  use CookbookWeb, :live_view

  alias Cookbook.Books
  alias Cookbook.Books.Book

  def render(assigns) do
    ~H"""
    <div class="row">
      <div class="col">
        <h4>Please write a summary using Markdown</h4>
        <.form let={f} for={@changeset} phx-change="change" class="mb-5">
          <div class="mb-3">
            <%= textarea(f, :summary, class: "form-control", rows: 20) %>
          </div>
        </.form>
      </div>

      <div class="col">
        <h4>Live preview</h4>
        <%= raw(Earmark.as_html!(@changeset.changes[:summary])) %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{changeset: Books.change_book(%Book{}, %{summary: initial_summary()})})}
  end

  def handle_event("change", %{"book" => params}, socket) do
    changeset = %Book{} |> Books.change_book(params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  defp initial_summary do
    "# Summary

### The beginning

It was a dark and stormy night.

I like this book because it
- is good
- is not too long
- has a nice cover
    "
  end
end
