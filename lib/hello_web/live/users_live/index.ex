defmodule HelloWeb.UsersLive.Index do
  use HelloWeb, :live_view

  alias Hello.Accounts
  alias Hello.Accounts.Users

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users_collection, Accounts.list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Users")
    |> assign(:users, Accounts.get_users!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Users")
    |> assign(:users, %Users{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:users, nil)
  end

  @impl true
  def handle_info({HelloWeb.UsersLive.FormComponent, {:saved, users}}, socket) do
    {:noreply, stream_insert(socket, :users_collection, users)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    users = Accounts.get_users!(id)
    {:ok, _} = Accounts.delete_users(users)

    {:noreply, stream_delete(socket, :users_collection, users)}
  end
end
