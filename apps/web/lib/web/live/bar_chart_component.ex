defmodule Web.BarChartComponent do
  use Web, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div phx-hook="ChartComponent" id="barchart-<%= @id %>">
      <div id="canvas-holder" style="position: relative;" phx-update="ignore">
        <canvas class="chart w-full h-full"></canvas>
      </div>
      <div id="bar-chart-data-holder"
          data-x="<%= Jason.encode!(@data) %>"
          data-type="bar"
          data-column-labels="<%= Jason.encode!(@column_labels) %>"
          data-label="<%= @label %>">
      </div>
    </div>
    """
  end
end
