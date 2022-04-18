defmodule CookbookWeb.SheetJsLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <script lang="javascript" src="https://cdn.sheetjs.com/xlsx-0.18.5/package/dist/xlsx.full.min.js">
    </script>
    <h1>Upload a spreadsheet file</h1>

    <input type="file" id="file_input_element" />
    <div id="sheet_js_div" phx-hook="SheetJS" />

    <%= if Enum.any?(@headers) do %>
      <table class="table table-striped table-sm mt-5">
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
                <td><%= cell %></td>
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </table>
    <% end %>

    <script>
      function handleFile(e) {
        var file = e.target.files[0];
        var reader = new FileReader();
        reader.onload = function(e) {
          var data = e.target.result;
          var workbook = XLSX.read(e.target.result);
          var worksheet = workbook.Sheets[workbook.SheetNames[0]];
          var jsa = XLSX.utils.sheet_to_json(worksheet, {header: 1});

          const event = new CustomEvent('rows_added', { detail: jsa });
          window.dispatchEvent(event);
        };
        reader.readAsArrayBuffer(file);
      }

      document.getElementById('file_input_element').addEventListener("change", handleFile, false);
    </script>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(headers: [], rows: [])}
  end

  def handle_event("rows_added", rows, socket) do
    [headers | rows] = rows
    {:noreply, socket |> assign(headers: headers, rows: rows)}
  end
end
