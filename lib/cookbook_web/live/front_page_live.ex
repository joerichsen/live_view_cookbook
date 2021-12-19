defmodule CookbookWeb.FrontPageLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Welcome to the Phoenix LiveView Cookbook</h1>
    <h3>This repo contains examples of using Phoenix LiveView</h3>

    <p>Check out the live demo at <a href="https://liveviewcookbook.dev/">https://liveviewcookbook.dev/</a></p>

    <p>The plan is to have the following examples</p>

    <ul>
      <li><a href="https://liveviewcookbook.dev/hello_world">Hello World</a></li>
      <li>Form with validation</li>
      <li>Dynamic nested form</li>
      <li>Multistep wizard form</li>
      <li>File upload</li>
      <li>File upload to S3</li>
      <li>Picture upload and cropping</li>
      <li>Showing a Bootstrap modal</li>
      <li>Using a date picker</li>
      <li>Navbar</li>
    </ul>

    <p>Feel free to add a PR if you think that an example is missing.</p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
