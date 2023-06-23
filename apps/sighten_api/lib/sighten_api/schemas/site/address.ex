defmodule SightenApi.Schemas.Site.Address do
  defstruct ~w(
    address_line_1
    auto_design_available
    city_name
    county_fips
    county_name
    eagleview_data_available
    elevation
    google_places_id
    image_url
    latitude
    longitude
    overridden
    site
    state_abbreviation
    sunroof_allow_retry
    sunroof_building
    sunroof_center_latitude
    sunroof_center_longitude
    sunroof_image_data_available
    sunroof_radius
    sunroof_rsd_imagery_available
    sunroof_rsd_imagery_date
    sunroof_rsd_imagery_radius
    sunroof_shade_data_available
    uuid
    zipcode
  )a

  def new(args) do
    %__MODULE__{
      address_line_1: args["address_line_1"],
      auto_design_available: args["auto_design_available"],
      city_name: args["city_name"],
      county_fips: args["county_fips"],
      county_name: args["county_name"],
      eagleview_data_available: args["eagleview_data_available"],
      elevation: args["elevation"],
      google_places_id: args["google_places_id"],
      image_url: args["image_url"],
      latitude: args["latitude"],
      longitude: args["longitude"],
      overridden: args["overridden"],
      site: args["site"],
      state_abbreviation: args["state_abbreviation"],
      sunroof_allow_retry: args["sunroof_allow_retry"],
      sunroof_building: args["sunroof_building"],
      sunroof_center_latitude: args["sunroof_center_latitude"],
      sunroof_center_longitude: args["sunroof_center_longitude"],
      sunroof_image_data_available: args["sunroof_image_data_available"],
      sunroof_radius: args["sunroof_radius"],
      sunroof_rsd_imagery_available: args["sunroof_rsd_imagery_available"],
      sunroof_rsd_imagery_date: args["sunroof_rsd_imagery_date"],
      sunroof_rsd_imagery_radius: args["sunroof_rsd_imagery_radius"],
      sunroof_shade_data_available: args["sunroof_shade_data_available"],
      uuid: args["uuid"],
      zipcode: args["zipcode"]
    }
  end
end
