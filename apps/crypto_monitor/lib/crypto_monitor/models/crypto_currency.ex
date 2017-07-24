defmodule Crypto.Currency do
  @moduledoc """
  Place holder for currency
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency" do
    field :name
    field :quantity, :integer
  end

  def changeset(currency, params \\ :empty) do
    currency
      |> cast(params, [:quantity, :name])
  end
end
