defmodule CookbookWeb.FrontPageLive do
  use CookbookWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Welcome to the Phoenix LiveView Cookbook</h1>
    <h4>
      This contains examples of using
      <a href="https://github.com/phoenixframework/phoenix_live_view">Phoenix LiveView</a>
    </h4>

    <%= for recipe <- Cookbook.Recipes.all() do %>
      <div class="row pt-3">
        <div class="col-3"><%= recipe.title %></div>
        <div class="col">
          <%= if Map.get(recipe, :link) do %>
            <%= link("Demo", to: "/#{recipe.name}", class: "btn btn-outline-success btn-sm ml-5") %>
          <% else %>
            <%= live_redirect("Demo",
              to: "/#{recipe.name}",
              class: "btn btn-outline-success btn-sm ml-5"
            ) %>
          <% end %>

          <%= if Map.get(recipe, :code) do %>
            <a
              href={
                "https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/#{recipe.code}_live.ex"
              }
              class="btn btn-outline-primary btn-sm"
            >
              Code
            </a>
          <% else %>
            <a
              href={
                "https://github.com/joerichsen/live_view_cookbook/blob/main/lib/cookbook_web/live/#{recipe.name}_live.ex"
              }
              class="btn btn-outline-primary btn-sm"
            >
              Code
            </a>
          <% end %>

          <%= if Map.get(recipe, :commit) do %>
            <a
              href={"https://github.com/joerichsen/live_view_cookbook/commit/#{recipe.commit}"}
              class="btn btn-outline-primary btn-sm"
            >
              Initial Commit
            </a>
          <% end %>
        </div>
      </div>
    <% end %>

    <%= for todo <- Cookbook.Recipes.todos() do %>
      <div class="row pt-3">
        <div class="col-3"><%= todo %></div>
        <div class="col">TODO</div>
      </div>
    <% end %>

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
