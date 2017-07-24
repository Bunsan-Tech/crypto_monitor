defmodule Crypto.Authentication  do
  @moduledoc """
  Module for authenticate user
  """
 import Plug.Conn

  def authenticated?(conn) do
    token = get_session(conn, :token)
    if token, do: true, else: false
  end

end
