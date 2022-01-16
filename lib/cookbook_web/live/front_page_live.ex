defmodule CookbookWeb.FrontPageLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Welcome to the Phoenix LiveView Cookbook</h1>
    <h4>This contains examples of using <a href="https://github.com/phoenixframework/phoenix_live_view">Phoenix LiveView</a></h4>

    <div class="row pt-3">
      <div class="col-3">Hello World</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/hello_world", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/hello_world_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Progress</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/progress", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/progress_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Form with validation</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/form_with_validation", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/form_with_validation_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
        <a href="https://github.com/joerichsen/live_view_cookbook/commit/032298835e028ea41df4ab5dc4659af1f3c91474" class="btn btn-outline-primary btn-sm">Initial Commit</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Displaying flash messages</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/flash", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/flash_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Showing a Bootstrap modal</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/modal", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/modal_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
        <a href="https://github.com/joerichsen/live_view_cookbook/commit/0fdc7072ff9df7dbac3ad90801764d0f146499bd" class="btn btn-outline-primary btn-sm">Initial Commit</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Multistep wizard form</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/multi_step_wizard", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/multi_step_wizard_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Upload and display a XLSX file</div>
      <div class="col">
        <%= live_redirect "Demo", to: "/xlsx_file_upload_and_display", class: "btn btn-outline-success btn-sm ml-5" %>
        <a href="https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/xlsx_file_upload_and_display_live.ex" class="btn btn-outline-primary btn-sm">Code</a>
      </div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Dynamic nested form</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col-3">File upload</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col-3">File upload to S3</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Picture upload and cropping</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Using a date picker</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-3">
      <div class="col-3">Navbar</div>
      <div class="col">TODO</div>
    </div>

    <div class="row pt-5">
      <div class="col">
        Feel free to add a PR if you think that an example is missing.
        Check out the <a href="https://github.com/joerichsen/live_view_cookbook/">GitHub repo</a>.
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
