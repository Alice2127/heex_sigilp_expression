defmodule HelloWeb.UsersLive.FormComponent do
  use HelloWeb, :live_component

  alias Hello.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage users records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="users-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:age]} type="number" label="Age" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Users</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{users: users} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_users(users))
     end)}
  end

  @impl true
  def handle_event("validate", %{"users" => users_params}, socket) do
    changeset = Accounts.change_users(socket.assigns.users, users_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"users" => users_params}, socket) do
    save_users(socket, socket.assigns.action, users_params)
  end

  defp save_users(socket, :edit, users_params) do
    case Accounts.update_users(socket.assigns.users, users_params) do
      {:ok, users} ->
        notify_parent({:saved, users})

        {:noreply,
         socket
         |> put_flash(:info, "Users updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_users(socket, :new, users_params) do
    case Accounts.create_users(users_params) do
      {:ok, users} ->
        notify_parent({:saved, users})

        {:noreply,
         socket
         |> put_flash(:info, "Users created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
