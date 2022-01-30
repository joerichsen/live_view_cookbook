defmodule Cookbook.Recipes do
  def all do
    [
      %{title: "Hello World", name: "hello_world"},
      %{title: "Progress", name: "progress"},
      %{
        title: "Form with validation",
        name: "form_with_validation",
        commit: "032298835e028ea41df4ab5dc4659af1f3c91474"
      },
      %{title: "Displaying flash messages", name: "flash"},
      %{
        title: "Showing a Bootstrap modal",
        name: "modal",
        commit: "0fdc7072ff9df7dbac3ad90801764d0f146499bd"
      },
      %{title: "Multistep wizard form", name: "multi_step_wizard"},
      %{title: "Upload and display a XLSX file", name: "xlsx_file_upload_and_display"},
      %{
        title: "Keep LiveView state across redirects",
        name: "keep_liveview_across_redirect1",
        code: "keep_liveview_across_redirect"
      },
      %{title: "Live render markdown", name: "markdown_preview"},
      %{title: "FullCalendar integration", name: "full_calendar", link: true},
      %{title: "Table with filtering, sorting, and pagination", name: "table", link: true},
      %{title: "JS: Focus element and copy to clipboard", name: "focus_and_copy", link: true},
      %{title: "Browse files", name: "browse_files"}
    ]
  end

  def todos do
    [
      "Dynamic nested form",
      "File upload",
      "File upload to S3",
      "Picture upload and cropping",
      "Using a date picker",
      "Navbar"
    ]
  end
end
