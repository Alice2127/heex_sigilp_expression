defmodule Hello.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hello.Accounts` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        age: 42,
        name: "some name"
      })
      |> Hello.Accounts.create_users()

    users
  end
end
