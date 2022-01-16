defmodule CookbookWeb.XlxsFileUploadAndDisplayLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <form id="upload-form" phx-submit="save" phx-change="validate">
      <%= live_file_input @uploads.xlsx_file %>
      <button type="submit" class="btn btn-primary">Upload XLSX file</button>
    </form>

    <%= if Enum.any?(@headers) do %>
      <table class="table mt-5">
        <thead>
          <tr>
            <%= for header <- @headers do %>
              <th><%= header %></th>
            <% end %>
          </tr>
        </thead>
        <tbody>
          <%= for row <- @rows do %>
            <tr>
              <%= for cell <- row do %>
                <td><%= format(cell) %></td>
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </table>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(headers: [], rows: []) |> allow_upload(:xlsx_file, accept: ~w(.xlsx))}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    [rows] =
      consume_uploaded_entries(socket, :xlsx_file, fn %{path: path}, _entry ->
        {:ok, table_id} = Xlsxir.multi_extract(path, 0)
        Xlsxir.get_list(table_id)
      end)

    [headers | rows] = rows

    {:noreply, socket |> assign(headers: headers, rows: rows)}
  end

  defp format(val) when is_binary(val), do: val
  defp format(val) when is_number(val), do: val
  defp format(val) when is_boolean(val), do: val
  defp format({_year, _month, _day} = val), do: Date.from_erl!(val)
  defp format(_), do: "UNKNOWN TYPE"
end
