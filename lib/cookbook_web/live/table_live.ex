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
        <%= for row <- @rows do %>
          <tr>
            <td><%= row.name %></td>
            <td><%= row.birthday %></td>
            <td><%= row.favorite_color %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    socket = socket |> assign_rows() |> assign_sort_variables() |> sort()
    {:ok, socket}
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

  defp assign_sort_variables(socket) do
    assign(socket, sort_by: :name, sort_direction: :asc)
  end

  defp assign_rows(socket) do
    rows =
      Enum.map(1..20, fn _ ->
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
