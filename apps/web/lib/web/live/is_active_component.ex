defmodule Web.IsActiveComponent do
  use Web, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <%= if @is_active do %>
      <svg fill="currentColor" viewBox="0 0 20 20" class="text-rose-600 h-6 w-6">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
    <% else %>
      <svg fill="currentColor" viewBox="0 0 20 20" class="text-gray-300 h-6 w-6">>
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd">
      </path></svg>
    <% end %>
    """
  end
end
