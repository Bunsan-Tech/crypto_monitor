defmodule Crypto.Metrics do
  @moduledoc """
  Bank for crypto currencies
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias CryptoMnesiaMonitor.Repo
  
  schema "metrics" do
    field :date, Ecto.DateTime
    field :value, :decimal
    field :currency, :string
  end

  def create(params) do
    chs = changeset(%Crypto.Metrics{}, params)
    Repo.insert!(chs)
  end

  def changeset(metric, params \\ :empty) do
    metric
      |> cast(params, [:date, :value, :currency])
  end

  def get_metrics(currency) do
    query = from m in Crypto.Metrics,
      where: m.currency == ^currency,
      select: m
    Repo.all(query)
  end

  def get_metrics({:last, limit}, currency) do
    query = from m in Crypto.Metrics,
      where: m.currency == ^currency,
      limit: ^limit,
      select: m
    Repo.all(query)
  end

end