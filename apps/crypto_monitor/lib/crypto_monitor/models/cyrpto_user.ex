defmodule Crypto.User do
  @moduledoc """
  Bank for crypto currencies
  """
  alias Crypto.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username
    field :pin
    field :confirm_pin
  end

  def changeset(user, params \\ :empty) do
    user
    |> cast(params, [:pin, :username, :confirm_pin])
  end

  def create(username, pin) do
    ConCache.put(:users, username, %{"eth" => 0,
                                     "btc" => 0,
                                     "usd" => 10_000,
                                     "PIN" => pin})
  end

  def get_balance(user, currency) do
    user_info = ConCache.get(:users, user)
    user_info[currency]
  end

  def get_info(user) do
    ConCache.get(:users, user)
  end

  def update_founds(:usd, user, ammount) do
    user_info = ConCache.get(:users, user)
    updated_info = %{user_info | "usd" => ammount + user_info["usd"]}
    ConCache.put(:users, user, updated_info)
  end

  def update_founds(user, currency, ammount) do
    user_info = ConCache.get(:users, user)
    updated_info = %{user_info | currency => ammount}
    ConCache.put(:users, user, updated_info)
  end

  def increment_founds(user, currency, ammount) do
    user_info = ConCache.get(:users, user)
    updated_info = %{user_info | currency => ammount + user_info[currency]}
    ConCache.put(:users, user, updated_info)
  end

  def commit_transaction(:buy, user, ammount) do
    balance = get_balance(user, "usd")
    if balance >= ammount do
      new_balance = balance - ammount
      IO.inspect new_balance
      User.update_founds(user, "usd", new_balance)
      {:ok, new_balance}
    else
      {:error, "Not enougth founds"}
    end
  end

  def commit_transaction(:sell, user, quantity, currency) do
    balance = get_balance(user, currency)
    if balance >= quantity do
      new_balance = balance - quantity
      User.update_founds(user, currency, new_balance)
      {:ok, new_balance}
    else
      {:error, "Not enougth #{currency} founds"}
    end
  end

end
