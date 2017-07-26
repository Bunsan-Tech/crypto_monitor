defmodule Crypto.Currency do
  @moduledoc """
  Place holder for currency
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(quantity)

  schema "currency" do
    field :name
    field :quantity
  end

  def changeset(currency, params \\ :empty) do
    currency
      |> cast(params, [:quantity, :name])
  end

  def buy_changeset(currency, params \\ :empty) do
    currency
      |> cast(params, @required_fields)
      |> validate_quantity("buy")
  end

  def sell_changeset(currency, params \\ :empty) do
    currency
      |> cast(params, @required_fields)
      |> validate_quantity("sell")
  end

  def validate_quantity(changeset, operation) do
    quantity = get_field(changeset, :quantity)
    cond do
      quantity == nil ->
        add_error(changeset, :invalid_data, "You should #{operation} at least one")
      is_negative?(quantity) == true ->
        add_error(changeset, :invalid_data, "Please provide a non negative quantity")
      true ->
        changeset
    end
  end

  defp is_negative?(quantity) do
    {qty, _} = Float.parse(quantity)
    if qty >= 0 do
      false
    else
      true
    end
  end
end
