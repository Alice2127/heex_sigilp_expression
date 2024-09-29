defmodule HelloWeb.UsersLive.Show do
  use HelloWeb, :live_view

  alias Hello.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:users, Accounts.get_users!(id))}
  end

  defp page_title(:show), do: "Show Users"
  defp page_title(:edit), do: "Edit Users"
end
