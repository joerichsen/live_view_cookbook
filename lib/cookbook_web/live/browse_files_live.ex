defmodule CookbookWeb.BrowseFilesLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <.form let={f} for={@filter_changeset} as="filter" phx-change="filter">
      <%= text_input f, :q, class: "form-control", phx_hook: "FocusOnMount" %>
    </.form>

    <ul class="list-group mt-3">
      <%= for file <- @filtered_files do %>
        <li class="list-group-item"><%= file %></li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    files = files()
    filtered_files = files |> Enum.slice(0..10)

    {:ok,
     assign(socket,
       files: files,
       filtered_files: filtered_files,
       filter_changeset: filter_changeset()
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
     socket |> assign(filter_changeset: filter_changeset, filtered_files: filtered_files)}
  end

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
