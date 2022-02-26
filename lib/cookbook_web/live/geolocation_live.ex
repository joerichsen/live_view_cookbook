defmodule CookbookWeb.GeolocationLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="geolocation-demo" phx-hook="GetGeolocation">
      <%= if @address do %>
        <h1>Your address is:</h1>
        <%= @address %>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(address: nil)}
  end

  def handle_event("position", %{"lat" => lat, "long" => long}, socket) do
    {:ok, coordinates} = Geocoder.call({lat, long})
    address = coordinates.location.formatted_address
    {:noreply, socket |> assign(address: address)}
  end
end
