defmodule CryptoMonitor.Bank do
  @moduledoc """
  Bank for crypto currencies
  """
  alias Crypto.User
  alias CryptoMonitor.Bank
  @doc """
  Starts a new Bank.
  """
  def start_link do
    Agent.start_link(fn -> %{"eth" => 0,
                             "eth_qty" => 100_000,
                             "btc_qty" => 100_000,
                             "btc" => 0} end, name: __MODULE__)
  end

  @doc """
  Updates a value for currency
  """
  def update(key, value) do
    Agent.update(Bank, &Map.put(&1, key, value))
  end

  @doc """
  Buys currency
  """
  def buy(currency, quantity, user) do
    sell_value = quantity * Bank.get(currency)
    with {:ok, _} <- User.commit_transaction(:buy, user, sell_value),
         {:ok, _} <- Bank.deliver_founds(currency, quantity),
         {:ok, _} <- User.update_founds(user, currency, quantity)
    do
      {:ok, "Thank you"}
    else
      err -> err
    end
  end

  def sell(currency, quantity, user) do
    buy_value = quantity * Bank.get(currency)
    with {:ok, _} <- User.commit_transaction(:sell, user, quantity, currency),
         {:ok, _} <- Bank.recover_founds(currency, quantity),
         {:ok, _} <- User.update_founds(:usd, user, buy_value)
    do
      {:ok, "Thank you"}
    else
      err -> err
    end
  end

  def deliver_founds(currency, quantity) do
    expend = Bank.get(currency <> "_qty") - quantity
    Bank.update(currency <> "_qty", expend)
    {:ok, "updated"}
  end

  def recover_founds(currency, quantity) do
    recover = Bank.get(currency <> "_qty") + quantity
    Bank.update(currency <> "_qty", recover)
    {:ok, "updated"}
  end
  @doc """
  Gets a value from the `bank` by `key`.
  """
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

end
