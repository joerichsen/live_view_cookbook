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
              <%= for col <- row do %>
                <td><%= col %></td>
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
        {:ok, package} = XlsxReader.open(path)
        {:ok, [{_sheet, rows} | _]} = XlsxReader.sheets(package)
        rows
      end)

    [headers | rows] = rows

    {:noreply, socket |> assign(headers: headers, rows: rows)}
  end
end
