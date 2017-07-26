defmodule Crypto.User do
  @moduledoc """
  Bank for crypto currencies
  """
  alias Crypto.User
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias CryptoMonitor.Repo

  @required_fields ~w(name pin)
  @optional_fields ~w(confirm_pin)

  schema "users" do
    field :name
    field :pin
    field :usd, :decimal
    field :eth, :decimal
    field :btc, :decimal
    field :confirm_pin, :string, virtual: true
  end

  def changeset(user, params \\ :empty) do
    user
      |> cast(params, [:pin, :name, :confirm_pin, :usd, :btc, :eth])
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
      case User.get_pin(user_name) == input_pin do
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

  def create(changeset) do
    Repo.insert(changeset)
  end

  def get_balance(user, currency) do
    user_info = get_info(user)
    Map.from_struct(user_info)[String.to_atom(currency)]
  end

  def get_info(user) do
    query = from u in Crypto.User,
          where: u.name == ^user,
          select: u
    Repo.one(query)
  end

  def get_name(user) do
    query = from u in "users",
          where: u.name == ^user,
          select: u.name
    Repo.one(query)
  end

  def get_pin(user) do
    query = from u in "users",
          where: u.name == ^user,
          select: u.pin
    Repo.one(query)
  end

  def update_founds(:usd, user, ammount) do
    user_info = get_info(user)
    changeset =
    change(user_info,
    %{:usd => Decimal.add(Decimal.new(ammount), user_info.usd)})
    Repo.update(changeset)
  end

  def update_founds(user, currency, ammount) do
    user_info = get_info(user)
    changeset = change(user_info, %{String.to_atom(currency) => ammount})
    Repo.update(changeset)
  end

  def increment_founds(user, currency, ammount) do
    user_info = get_info(user)
    balance = Map.from_struct(user_info)[String.to_atom(currency)]
    changeset =
    change(user_info,
    %{String.to_atom(currency) => Decimal.add(Decimal.new(ammount), balance)})
    Repo.update(changeset)
  end

  def commit_transaction(:buy, user, ammount) do
    balance = get_balance(user, "usd")
    if greater_or_equals(balance, Decimal.new(ammount)) do
      new_balance = Decimal.sub(balance, Decimal.new(ammount))
      User.update_founds(user, "usd", new_balance)
      {:ok, new_balance}
    else
      {:error, "Not enougth founds"}
    end
  end

  def commit_transaction(:sell, user, quantity, currency) do
    balance = get_balance(user, currency)
    if greater_or_equals(balance, Decimal.new(quantity)) do
      new_balance = Decimal.sub(balance, Decimal.new(quantity))
      User.update_founds(user, currency, new_balance)
      {:ok, new_balance}
    else
      {:error, "Not enougth #{currency} founds"}
    end
  end

  defp greater_or_equals(val_1, val_2) do
    if Decimal.compare(val_1, val_2) == Decimal.new(1) ||
       Decimal.compare(val_1, val_2) == Decimal.new(0) do
      true
    else
      false
    end
  end

end
