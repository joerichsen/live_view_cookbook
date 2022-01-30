defmodule CookbookWeb.FocusAndCopyLive do
  use CookbookWeb, :live_view

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <h4>Focus examples</h4>
    <div class="row">
      <div class="col">
        This is focused on mount
        <input type="text" id="user_name" class="form-control" phx-hook="FocusOnMount" />
      </div>
    </div>

    <div class="row mt-3">
      <div class="col">
        <input type="text" id="user_email" class="form-control" />
      </div>
      <div class="col">
        <button class="btn btn-primary" phx-click={JS.dispatch("set-focus", to: "#user_email")}>Set focus</button>
      </div>
    </div>

    <script>
      window.addEventListener("set-focus", (e) => {
        e.target.focus()
      });
    </script>

    <h4 class="mt-5">Copy to clipboard example</h4>
    <div class="input-group mb-3">
      <input type="text" id="token" value={@token} class="form-control" />
      <span class="input-group-text" role="button" phx-click={JS.dispatch("copy-to-clipboard", to: "#token") |> JS.hide(to: "#clipboard_icon") |> JS.show(to: "#copied_to_clipboard_icon")}>
        <i class="bi bi-clipboard" id="clipboard_icon"></i>
        <i class="bi bi-check text-success" style="display: none" id="copied_to_clipboard_icon"></i>
      </span>
    </div>

    <script>
      window.addEventListener("copy-to-clipboard", (e) => {
        if ("clipboard" in navigator) {
          navigator.clipboard.writeText(e.target.value);
        } else {
          alert("Your browser does not support copy to clipboard");
        }
      });
    </script>
    """
  end

  def mount(_params, _session, socket) do
    token = :crypto.strong_rand_bytes(32) |> Base.encode64(padding: false) |> binary_part(0, 32)
    {:ok, assign(socket, token: token)}
  end
end
