defmodule CookbookWeb.FlashLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="row">
      <div class="col">
        <button phx-click="show-flash-success" class="btn btn-success">Try me!</button>
      </div>
      <div class="col-8">
        <button phx-click="show-flash-fail" class="btn btn-danger">
          Press this dangerous button
        </button>
      </div>
    </div>

    <%= if @flash != %{} do %>
      <div class="row mt-3">
        <div class="col">
          <button phx-click="clear-flash" class="btn btn-primary">Clear the flash messages</button>
        </div>
      </div>
    <% end %>
    """
  end

  def handle_event("show-flash-success", _params, socket) do
    {:noreply, socket |> put_flash(:info, "It worked")}
  end

  def handle_event("show-flash-fail", _params, socket) do
    {:noreply, socket |> put_flash(:error, "Uh oh, it didn't work")}
  end

  def handle_event("clear-flash", _params, socket) do
    {:noreply, socket |> clear_flash()}
  end
end
