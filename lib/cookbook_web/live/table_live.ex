defmodule CookbookWeb.TableLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="row">
      <div class="col">
        <.form let={f} for={@page_size_changeset} as="page_size" phx-change="change_page_size">
          Showing
          <%= select(f, :page_size, [5, 10, 20, 50, 100],
            class: "form-select mx-1",
            style: "display: inline; width: 80px"
          ) %> per page
        </.form>
      </div>

      <div class="col">
        <.form let={f} for={@filter_changeset} as="filter" phx-change="filter">
          <div class="row">
            <div class="col">
              <%= text_input(f, :q, class: "form-control", placeholder: "Search by name") %>
            </div>
            <div class="col">
              <%= multiple_select(f, :favorite_colors, @favorite_colors, class: "form-select") %>
            </div>
          </div>
        </.form>
      </div>
    </div>

    <table class="table table-striped">
      <thead>
        <tr>
          <.th field={:name} sort_direction={@sort_direction} sort_by={@sort_by}>Name</.th>
          <.th field={:birthday} sort_direction={@sort_direction} sort_by={@sort_by}>Birthday</.th>
          <.th field={:favorite_color} sort_direction={@sort_direction} sort_by={@sort_by}>
            Favorite Color
          </.th>
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

    <div class="row">
      <div class="col mb-2">
        Showing <%= min((@page - 1) * @page_size + 1, length(@filtered_rows)) %> to
        <%= min(@page * @page_size, length(@filtered_rows)) %> of <%= length(@filtered_rows) %>
        entries
      </div>
      <div class="col">
        <nav class="float-end">
          <ul class="pagination">
            <li class={"page-item #{(@page == 1 && "disabled") || ""}"}>
              <a class="page-link" href="#" phx-click="goto_page" phx-value-page={@page - 1}>
                Previous
              </a>
            </li>
            <%= for page <- (1..@total_pages) do %>
              <li class={"page-item #{(page == @page && "active") || ""}"}>
                <a class="page-link" href="#" phx-click="goto_page" phx-value-page={page}>
                  <%= page %>
                </a>
              </li>
            <% end %>
            <li class={"page-item #{(@page == @total_pages && "disabled") || ""}"}>
              <a class="page-link" href="#" phx-click="goto_page" phx-value-page={@page + 1}>Next</a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_rows()
      |> reset_sort_variables()
      |> reset_pagination_variables()
      |> assign_filter_changeset()
      |> filter()
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

    {:noreply, socket |> assign(page: 1) |> sort() |> paginate()}
  end

  def handle_event("change_page_size", %{"page_size" => params}, socket) do
    page_size = page_size_changeset(params).changes.page_size

    {:noreply,
     socket
     |> assign(page_size: page_size, page: 1, page_size_changeset: page_size_changeset(params))
     |> paginate()}
  end

  def handle_event("filter", %{"filter" => params}, socket) do
    {:noreply,
     socket
     |> assign(filter_changeset: filter_changeset(params), page: 1)
     |> filter()
     |> sort()
     |> paginate()}
  end

  defp filter(socket) do
    q = socket.assigns.filter_changeset.changes |> Map.get(:q)

    filtered_rows =
      if q do
        socket.assigns.rows |> Enum.filter(&String.match?(&1.name, ~r/#{q}/i))
      else
        socket.assigns.rows
      end

    favorite_colors = socket.assigns.filter_changeset.changes |> Map.get(:favorite_colors)

    filtered_rows =
      if favorite_colors do
        filtered_rows |> Enum.filter(&Enum.member?(favorite_colors, &1.favorite_color))
      else
        filtered_rows
      end

    assign(socket, filtered_rows: filtered_rows)
  end

  # Dates such as birthdays require special sorting in Elixir
  defp sort(%{assigns: %{sort_direction: sort_direction, sort_by: :birthday}} = socket) do
    rows =
      socket.assigns.filtered_rows
      |> Enum.sort_by(&Map.get(&1, socket.assigns.sort_by), {sort_direction, Date})

    assign(socket, filtered_rows: rows)
  end

  defp sort(%{assigns: %{sort_direction: sort_direction}} = socket) do
    rows =
      socket.assigns.filtered_rows
      |> Enum.sort_by(&Map.get(&1, socket.assigns.sort_by), sort_direction)

    assign(socket, filtered_rows: rows)
  end

  defp paginate(%{assigns: %{page: page, page_size: page_size}} = socket) do
    total_pages = ceil(length(socket.assigns.filtered_rows) / page_size)

    rows_on_this_page =
      socket.assigns.filtered_rows |> Enum.slice((page - 1) * page_size, page_size)

    assign(socket, total_pages: total_pages, rows_on_this_page: rows_on_this_page)
  end

  defp reset_sort_variables(socket) do
    assign(socket, sort_by: :name, sort_direction: :asc)
  end

  defp reset_pagination_variables(socket) do
    page_size = 10

    assign(socket,
      page: 1,
      page_size: page_size,
      page_size_changeset: page_size_changeset(%{page_size: page_size})
    )
  end

  defp assign_filter_changeset(socket) do
    assign(socket,
      filter_changeset: filter_changeset(),
      favorite_colors:
        socket.assigns.rows |> Enum.map(& &1.favorite_color) |> Enum.uniq() |> Enum.sort()
    )
  end

  defp page_size_changeset(params) do
    {%{}, %{page_size: :integer}} |> Ecto.Changeset.cast(params, [:page_size])
  end

  defp filter_changeset(params \\ %{}) do
    {%{}, %{favorite_colors: {:array, :string}, q: :string}}
    |> Ecto.Changeset.cast(params, [:favorite_colors, :q])
  end

  defp assign_rows(socket) do
    rows =
      Enum.map(1..54, fn _ ->
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

      <%= if @sort_by == @field do %>
        <%= if @sort_direction == :asc do %>
          <i class="bi bi-arrow-up-short"></i>
        <% else %>
          <i class="bi bi-arrow-down-short"></i>
        <% end %>
      <% end %>
    </th>
    """
  end
end
