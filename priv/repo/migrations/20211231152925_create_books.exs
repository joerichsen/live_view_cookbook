defmodule Cookbook.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :summary, :text
      add :pages, :integer

      timestamps()
    end
  end
end
