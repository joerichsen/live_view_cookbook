defmodule CookbookWeb.ModalLive do
  use CookbookWeb, :live_view

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <button phx-click={show_modal()} class="btn btn-primary">Launch Modal</button>

    <div class="modal fade" id="modal" tabindex="-1">
      <div class="modal-dialog">
        <div
          class="modal-content"
          phx-click-away={hide_modal()}
          phx-window-keydown={hide_modal()}
          phx-key="escape"
        >
          <div class="modal-header">
            <h5 class="modal-title">Modal title</h5>
            <button type="button" class="btn-close" phx-click={hide_modal()}></button>
          </div>
          <div class="modal-body">
            Woohoo, you're reading this text in a modal!
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" phx-click={hide_modal()}>Close</button>
          </div>
        </div>
      </div>
    </div>

    <div id="backdrop" class="fade show"></div>
    """
  end

  def show_modal() do
    %JS{}
    |> JS.add_class("show", to: "#modal")
    |> JS.dispatch("display-block", to: "#modal")
    |> JS.add_class("modal-backdrop", to: "#backdrop")
  end

  def hide_modal() do
    %JS{}
    |> JS.remove_class("show", to: "#modal")
    |> JS.dispatch("display-none", to: "#modal")
    |> JS.remove_class("modal-backdrop", to: "#backdrop")
  end
end
