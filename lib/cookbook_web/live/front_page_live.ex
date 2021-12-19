defmodule CookbookWeb.FrontPageLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Welcome to the Phoenix LiveView Cookbook</h1>
    <h3>This contains examples of using Phoenix LiveView</h3>

    <p>The plan is to have the following examples:</p>

    <p>
      Hello World
      <a href="https://liveviewcookbook.dev/hello_world" class="btn btn-outline-success ml-5">Demo</a>
      <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/hello_world_live.ex" class="btn btn-outline-primary">Code</a>
    </p>

    <p>Form with validation (TODO)</p>
    <p>Dynamic nested form (TODO)</p>
    <p>Multistep wizard form (TODO)</p>
    <p>File upload (TODO)</p>
    <p>File upload to S3 (TODO)</p>
    <p>Picture upload and cropping (TODO)</p>
    <p>Showing a Bootstrap modal (TODO)</p>
    <p>Using a date picker (TODO)</p>
    <p>Navbar (TODO)</p>

    <p>Feel free to add a PR if you think that an example is missing.</p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
