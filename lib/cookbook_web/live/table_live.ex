defmodule CookbookWeb.TableLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <table class="table">
      <thead>
        <tr>
          <.th field={:name} sort_direction={@sort_direction}>Name</.th>
          <.th field={:birthday} sort_direction={@sort_direction}>Birthday</.th>
          <.th field={:favorite_color} sort_direction={@sort_direction}>Favorite Color</.th>
        </tr>
      </thead>
      <tbody>
        <%= for row <- @rows_on_this_page do %>
          <tr>
            <td><%= row.name %></td>
            <td><%= row.birthday %></td>
            <td><%= row.favorite_color %></td>
          </tr>
        <% end %>
      </tbody>
    </table>

    <nav>
      <ul class="pagination">
        <li class={"page-item #{@page == 1 && "disabled" || ""}"}><a class="page-link" href="#" phx-click="goto_page" phx-value-page={@page - 1}>Previous</a></li>
        <%= for page <- (1..@total_pages) do %>
          <li class={"page-item #{page == @page && "active" || ""}"}><a class="page-link" href="#" phx-click="goto_page" phx-value-page={page}><%= page %></a></li>
        <% end %>
        <li class={"page-item #{@page == @total_pages && "disabled" || ""}"}><a class="page-link" href="#" phx-click="goto_page" phx-value-page={@page + 1}>Next</a></li>
      </ul>
    </nav>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_rows()
      |> reset_sort_variables()
      |> reset_pagination_variables()
      |> sort()
      |> paginate()

    {:ok, socket}
  end

  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    socket = assign(socket, page: page) |> paginate()
    {:noreply, socket}
  end

  def handle_event("sort", %{"sort_by" => sort_by, "sort_direction" => sort_direction}, socket) do
    sort_by = String.to_existing_atom(sort_by)
    sort_direction = String.to_existing_atom(sort_direction)

    socket =
      if sort_by == socket.assigns.sort_by do
        # We already sorted by this field, so just reverse the sort order.
        assign(socket, sort_direction: (sort_direction == :asc && :desc) || :asc)
      else
        assign(socket, sort_by: sort_by, sort_direction: :asc)
      end

    {:noreply, socket |> sort()}
  end

  # Dates such as birthdays require special sorting in Elixir
  defp sort(%{assigns: %{sort_direction: sort_direction, sort_by: :birthday}} = socket) do
    rows =
      socket.assigns.rows
      |> Enum.sort_by(&Map.get(&1, socket.assigns.sort_by), {sort_direction, Date})

    assign(socket, rows: rows)
  end

  defp sort(%{assigns: %{sort_direction: sort_direction}} = socket) do
    rows =
      socket.assigns.rows |> Enum.sort_by(&Map.get(&1, socket.assigns.sort_by), sort_direction)

    assign(socket, rows: rows)
  end

  defp paginate(%{assigns: %{page: page, page_size: page_size}} = socket) do
    total_pages = ceil(length(socket.assigns.rows) / page_size)
    rows_on_this_page = socket.assigns.rows |> Enum.slice((page - 1) * page_size, page_size)
    assign(socket, total_pages: total_pages, rows_on_this_page: rows_on_this_page)
  end

  defp reset_sort_variables(socket) do
    assign(socket, sort_by: :name, sort_direction: :asc)
  end

  defp reset_pagination_variables(socket) do
    assign(socket, page: 1, page_size: 10)
  end

  defp assign_rows(socket) do
    rows =
      Enum.map(1..50, fn _ ->
        %{
          name: Faker.Person.first_name() <> " " <> Faker.Person.last_name(),
          birthday: Faker.Date.date_of_birth(),
          favorite_color: Faker.Color.name()
        }
      end)

    assign(socket, rows: rows)
  end

  def th(assigns) do
    ~H"""
    <th phx-click="sort" phx-value-sort_by={@field} phx-value-sort_direction={@sort_direction}>
      <%= render_slot(@inner_block) %>
    </th>
    """
  end
end
