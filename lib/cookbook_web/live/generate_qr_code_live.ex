defmodule CookbookWeb.GenerateQrCodeLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <.form let={f} for={@changeset} as="text" phx-change="update_qr_code" class="mb-5">
      <%= text_input f, :text, class: "form-control", placeholder: "Enter a text or a URL" %>
    </.form>

    <%= if @svg_as_base64 do %>
      <img src={"data:image/svg+xml;base64, #{@svg_as_base64}"} />
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    socket = socket |> assign(changeset: changeset(), svg_as_base64: nil)
    {:ok, socket}
  end

  def handle_event("update_qr_code", %{"text" => %{"text" => text}}, socket) do
    svg_as_base64 = text |> QRCode.create() |> Result.and_then(&QRCode.Svg.to_base64(&1))
    {:noreply, socket |> assign(svg_as_base64: svg_as_base64)}
  end

  defp changeset(params \\ %{}) do
    {%{}, %{text: :string}} |> Ecto.Changeset.cast(params, [:text])
  end
end
