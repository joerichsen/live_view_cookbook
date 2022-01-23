defmodule CookbookWeb.EventController do
  use CookbookWeb, :controller

  def index(conn, _params) do
    json(conn, events())
  end

  defp events do
    # Add 10 random birthdays
    Enum.map(1..10, fn _ ->
      %{
        title: Faker.Person.first_name() <> " " <> Faker.Person.last_name(),
        start: Date.add(Date.utc_today(), Enum.random(-30..30))
      }
    end)
  end
end
