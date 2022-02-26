defmodule CookbookWeb.BrowseFilesLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="browse_files_demo" phx-hook="ArrowKeyEvents">
      <.form let={f} for={@filter_changeset} as="filter" phx-change="filter">
        <%= text_input f, :q, class: "form-control", phx_hook: "FocusOnMount" %>
      </.form>

      <ul class="list-group mt-3">
        <%= for {file, index} <- Enum.with_index(@filtered_files) do %>
          <%= if index == @index do %>
            <li class="list-group-item bg-primary text-white"><%= file %></li>
          <% else %>
            <li class="list-group-item"><%= file %></li>
          <% end %>
        <% end %>
      </ul>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    files = files()
    filtered_files = files |> Enum.slice(0..10)

    {:ok,
     assign(socket,
       files: files,
       filtered_files: filtered_files,
       filter_changeset: filter_changeset(),
       index: 0
     )}
  end

  def handle_event("filter", %{"filter" => params}, socket) do
    filter_changeset = filter_changeset(params)
    q = filter_changeset.changes |> Map.get(:q)

    filtered_files =
      if q do
        socket.assigns.files |> Enum.filter(&String.match?(&1, ~r/#{q}/i))
      else
        socket.assigns.files |> Enum.slice(0..10)
      end

    {:noreply,
     socket
     |> assign(filter_changeset: filter_changeset, filtered_files: filtered_files, index: 0)}
  end

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply,
     socket
     |> assign(index: min(socket.assigns.index + 1, length(socket.assigns.filtered_files) - 1))}
  end

  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, socket |> assign(index: max(socket.assigns.index - 1, 0))}
  end

  def handle_event("keydown", _, socket), do: {:noreply, socket}

  defp filter_changeset(params \\ %{}) do
    {%{}, %{q: :string}} |> Ecto.Changeset.cast(params, [:q])
  end

  defp files do
    directory = "/tmp/live_view_cookbook"

    if !File.exists?(directory) do
      System.cmd(
        "git",
        "clone --branch main --depth=1 https://github.com/joerichsen/live_view_cookbook.git #{directory}"
        |> String.split(" ")
      )
    else
      System.cmd("git", "pull origin main" |> String.split(" "), cd: directory)
    end

    {files, 0} = System.cmd("git", ["ls-files"], cd: directory)
    files |> String.split("\n") |> Enum.reject(&(&1 == ""))
  end
end
