defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  import Phoenix.HTML.Form

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    socket = assign(socket, :form, to_form(Gists.change_gist(%Gist{})))
    {:ok, socket}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, _gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      # Putting the :action field of the changeset is necessary because if it is nil, it doesn't display any errors
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end
end
