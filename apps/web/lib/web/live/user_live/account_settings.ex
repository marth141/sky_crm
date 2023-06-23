defmodule Web.UserLive.AccountSettings do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_current_user(socket, session)}
  end
end
