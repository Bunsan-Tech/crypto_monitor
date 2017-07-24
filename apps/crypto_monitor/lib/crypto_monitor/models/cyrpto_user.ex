defmodule Crypto.User do
  @moduledoc """
  Bank for crypto currencies
  """
  alias Crypto.User
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name pin)
  @optional_fields ~w(confirm_pin)

  schema "users" do
    field :name
    field :pin
    field :confirm_pin
  end

  def changeset(user, params \\ :empty) do
    user
      |> cast(params, [:pin, :name, :confirm_pin])
  end

  def login_changeset(user, params) do
    user
      |> cast(params, @required_fields)
      |> validate_user
      |> validate_pin
  end

  def signup_changeset(user, params) do
    user
      |> cast(params, @required_fields)
      |> cast(params, @optional_fields)
      |> validate_unique_user
      |> validate_pin_match
  end

  def validate_user(changeset) do
    user_name = get_field(changeset, :name)
    case User.get_info(user_name) do
      nil ->
        add_error(changeset, :not_found, "User name #{user_name} not found")
      _ ->
        changeset
    end
  end

  def validate_pin(changeset) do
    if changeset.valid? do
      input_pin = get_field(changeset, :pin)
      user_name = get_field(changeset, :name)
      %{"PIN" => pin} = User.get_info(user_name)
      case pin == input_pin do
        true ->
          changeset
        false ->
          add_error(changeset, :wrong_pin, "User name or pin incorrect")
      end
    else
      changeset
    end
  end

  def validate_unique_user(changeset) do
    user_name = get_field(changeset, :name)
    case User.get_info(user_name) do
      nil ->
        changeset
      _ ->
        add_error(changeset, :not_found, "#{user_name} has been already taken")
    end
  end

  def validate_pin_match(changeset) do
    if changeset.valid? do
      pin = get_field(changeset, :pin)
      confirm_pin = get_field(changeset, :confirm_pin)
      case pin == confirm_pin do
        true ->
          changeset
        false ->
          add_error(changeset, :wrong_pin, "Pins does not match")
      end
    else
      changeset
    end
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
