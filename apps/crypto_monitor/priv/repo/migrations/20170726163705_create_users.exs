defmodule CryptoMonitor.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :pin, :string
      add :usd, :decimal, default: 0
      add :eth, :decimal, default: 0
      add :btc, :decimal, default: 0
    end
  end
end
