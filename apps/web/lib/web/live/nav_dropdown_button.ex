defmodule Web.NavDropdownButton do
  use Web, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div id="navdropdown-<%= @id %>"
         x-data="{ open: false }"
         @keydown.escape="open = false"
         @click.away="open = false"
         class="relative">
      <div>
        <button @click="open = !open" class="px-3 py-2 rounded-md text-sm font-medium text-gray-300
                              hover:text-white hover:bg-rose-700 focus:outline-none
                              focus:text-white focus:bg-rose-700">
            <%= @title %>
        </button>
      </div>
      <div x-show="open"
           x-description="Dropdown panel, show/hide based on dropdown state."
           x-transition:enter="transition ease-out duration-100"
           x-transition:enter-start="transform opacity-0 scale-95"
           x-transition:enter-end="transform opacity-100 scale-100"
           x-transition:leave="transition ease-in duration-75"
           x-transition:leave-start="transform opacity-100 scale-100"
           x-transition:leave-end="transform opacity-0 scale-95"
           class="absolute left-1/2 transform -translate-x-1/2 mt-0 px-2 w-screen max-w-xs sm:px-0">
        <div class="origin-top-right absolute right-0 mt-2 mr-2 w-56 bg-white rounded-lg shadow-md py-2 text-gray-800 text-sm">
          <ul>

          </ul>
        </div>
      </div>

    </div>
    """
  end
end
