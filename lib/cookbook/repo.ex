defmodule Cookbook.Repo do
  use Ecto.Repo,
    otp_app: :cookbook,
    adapter: Ecto.Adapters.Postgres
end
