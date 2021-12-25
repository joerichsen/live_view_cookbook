defmodule CookbookWeb.FrontPageLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Welcome to the Phoenix LiveView Cookbook</h1>
    <h3>This contains examples of using <a href="https://github.com/phoenixframework/phoenix_live_view">Phoenix LiveView</a></h3>

    <div class="row">
      <div class="col">Hello World</div>
      <div class="col">
        <a href="/hello_world" class="btn btn-outline-success ml-5">Demo</a>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/hello_world_live.ex" class="btn btn-outline-primary">Code</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col">Progress</div>
      <div class="col">
        <a href="/progress" class="btn btn-outline-success ml-5">Demo</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col">Form with validation</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">Dynamic nested form</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">Multistep wizard form</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">File upload</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">File upload to S3</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">Picture upload and cropping</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">Showing a Bootstrap modal</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">Using a date picker</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col">Navbar</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-5">
      <div class="col">
        Feel free to add a PR if you think that an example is missing.
        Check out the <a href="https://github.com/joerichsen/live_view_cookbook/">GitHub repo.</a>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
