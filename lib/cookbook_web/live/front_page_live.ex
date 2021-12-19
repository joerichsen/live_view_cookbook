defmodule CookbookWeb.FrontPageLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <%= raw @readme %>
    """
  end

  def mount(_params, _session, socket) do
    readme = File.read!("README.md")
    html = Earmark.as_html!(readme)
    {:ok, assign(socket, :readme, html)}
  end
end
