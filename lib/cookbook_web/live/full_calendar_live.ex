defmodule CookbookWeb.FullCalendarLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.css" />

    <h1>Birthday Calendar</h1>

    <.form let={f} for={:event} phx-submit="add_event" class="mb-5">
      <div class="row">
        <div class="col">
          <%= label(f, :birthday) %>
          <%= date_input(f, :birthday, class: "form-control") %>
        </div>
        <div class="col">
          <%= label(f, :name) %>
          <%= text_input(f, :name, placeholder: "Enter name", class: "form-control") %>
        </div>
        <div class="col pt-4">
          <%= submit("Add Event", class: "btn btn-sm btn-primary") %>
        </div>
      </div>
    </.form>

    <div id="calendar" phx-update="ignore" phx-hook="FullCalendar" />

    <script>
      window.addEventListener("phx:event-added", (e) => {
        calendar.addEvent(e.detail);
      });
    </script>
    """
  end

  def handle_event("add_event", %{"event" => %{"birthday" => start, "name" => title}}, socket) do
    {:noreply, socket |> push_event("event-added", %{start: start, title: title})}
  end
end
