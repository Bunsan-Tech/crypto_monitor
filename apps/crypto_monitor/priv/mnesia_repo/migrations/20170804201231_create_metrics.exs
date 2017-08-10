defmodule CryptoMnesiaMonitor.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:metrics, engine: :set) do
      add :date, :naive_datetime 
      add :value, :string
      add :currency, :string 
      add :id, :string
    end
  end
end
