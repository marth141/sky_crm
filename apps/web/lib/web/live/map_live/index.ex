defmodule Web.MapLive.Index do
  use Web, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_current_user(session)
     |> assign(:addresses, SkylineOperations.MapGenserver.read_ets() |> Jason.encode!())
     |> assign(:search_address_lat_lng, nil)}
  end

  @impl true
  def handle_event("search-address", %{"address" => address}, socket) do
    {:ok, %{lat: lat, lon: lon}} =
      Geocoder.call(
        address: address,
        key: Application.get_env(:geocoder, :worker)[:key],
        timeout: :infinity
      )

    {:noreply,
     socket
     |> assign(:search_address_lat_lng, %{"lat" => lat, "lng" => lon} |> Jason.encode!())}
  end
end
