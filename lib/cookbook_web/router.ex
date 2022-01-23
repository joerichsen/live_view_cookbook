defmodule CookbookWeb.Router do
  use CookbookWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CookbookWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookbookWeb do
    pipe_through :browser

    live "/", FrontPageLive
    live "/hello_world", HelloWorldLive
    live "/progress", ProgressLive
    live "/form_with_validation", FormWithValidationLive
    live "/flash", FlashLive
    live "/modal", ModalLive
    live "/multi_step_wizard", MultiStepWizardLive
    live "/xlsx_file_upload_and_display", XlxsFileUploadAndDisplayLive
    live "/keep_liveview_across_redirect1", LiveView1
    live "/keep_liveview_across_redirect2", LiveView2
    live "/markdown_preview", MarkdownPreviewLive
    live "/full_calendar", FullCalendarLive
    get "/events", EventController, :index
    live "/table", TableLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookbookWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CookbookWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
