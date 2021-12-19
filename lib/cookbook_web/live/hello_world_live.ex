defmodule CookbookWeb.HelloWorldLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Hello World</h1>
    """
  end
end
