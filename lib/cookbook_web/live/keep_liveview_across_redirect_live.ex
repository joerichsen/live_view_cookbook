defmodule CookbookWeb.EmbeddedLiveView do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="card mt-1 mb-3">
      <div class="card-body">
        This LiveView is embedded in another LiveView
        <br>
        Loaded at <%= @current_time %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_time: Time.utc_now()), layout: false}
  end
end

defmodule CookbookWeb.LiveView1 do
  use CookbookWeb, :live_view

  alias CookbookWeb.{EmbeddedLiveView, LiveView2}

  def render(assigns) do
    ~H"""
    <h2>This is LiveView 1</h2>

    <h4>This is an embedded LiveView with the sticky option</h4>
    <%= live_render(@socket, EmbeddedLiveView, id: "first_embedded_live_view", sticky: true) %>

    <h4>This is an embedded LiveView without the sticky option</h4>
    <%= live_render(@socket, EmbeddedLiveView, id: "second_embedded_live_view") %>

    <%= live_redirect "Redirect to LiveView 2", to: Routes.live_path(@socket, LiveView2), class: "btn btn-primary" %>
    """
  end
end

defmodule CookbookWeb.LiveView2 do
  use CookbookWeb, :live_view

  alias CookbookWeb.{EmbeddedLiveView, LiveView1}

  def render(assigns) do
    ~H"""
    <h2>This is LiveView 2</h2>

    <h4>This is an embedded LiveView with the sticky option</h4>
    <%= live_render(@socket, EmbeddedLiveView, id: "first_embedded_live_view", sticky: true) %>

    <h4>This is an embedded LiveView without the sticky option</h4>
    <%= live_render(@socket, EmbeddedLiveView, id: "second_embedded_live_view") %>

    <%= live_redirect "Redirect to LiveView 1", to: Routes.live_path(@socket, LiveView1), class: "btn btn-primary" %>
    """
  end
end
