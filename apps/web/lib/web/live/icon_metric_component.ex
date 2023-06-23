defmodule Web.IconMetricComponent do
  use Web, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, description: "")}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="bg-white overflow-hidden shadow rounded-lg hover:shadow-lg">
      <div class="px-4 py-5 sm:p-6">
        <div class="flex items-center">
          <div class="flex-shrink-0 bg-rose-400 rounded-full p-3">
            <%= @inner_content.([]) %>
          </div>
          <div class="ml-5 w-0 flex-1">
            <dl>
              <dt class="text-sm leading-5 font-medium text-gray-600 truncate">
                <%= @label %>
              </dt>
              <dd class="flex items-baseline">
                <div class="text-2xl leading-8 font-semibold text-gray-900">
                  <%= @value %>
                </div>
              </dd>
              <dd class="flex items-baseline">
                <div class="text-xs leading-5 font-medium text-gray-600">
                  <%= @description %>
                </div>
              </dd>
            </dl>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
