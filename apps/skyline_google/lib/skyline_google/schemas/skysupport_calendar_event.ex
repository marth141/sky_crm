defmodule SkylineGoogle.SkySupportCalendarEvent do
  def new(
        %{properties: deal_properties},
        %{} = contact_owner,
        %{} = deal_owner,
        [%{} | _tail] = solar_consultations
      ) do
    latest_solar_consultation =
      Enum.sort_by(solar_consultations, & &1.engagement["id"], :desc) |> List.last()

    {:ok,
     %GoogleApi.Calendar.V3.Model.Event{
       updated: DateTime.utc_now(),
       kind: "calendar#event",
       organizer: %GoogleApi.Calendar.V3.Model.EventOrganizer{
         displayName: "Appointments",
         email: "@group.calendar.google.com",
         self: true
       },
       attachments: nil,
       creator: %GoogleApi.Calendar.V3.Model.EventCreator{
         email: "it_bot@org"
       },
       end: %GoogleApi.Calendar.V3.Model.EventDateTime{
         date: nil,
         dateTime:
           latest_solar_consultation.metadata["endTime"] |> DateTime.from_unix!(:millisecond),
         timeZone: "America/Denver"
       },
       description: """
       Setter: #{deal_owner.firstName} #{deal_owner.lastName}
       Closer: #{contact_owner.firstName} #{contact_owner.lastName}

       Address:
       #{deal_properties["street_address"]}, #{deal_properties["city"]}, #{deal_properties["state_region"]}, #{deal_properties["zip"]}, #{deal_properties["country"]}
       """,
       guestsCanSeeOtherGuests: true,
       attendees: [
         %GoogleApi.Calendar.V3.Model.EventAttendee{email: "skysupport@org"}
       ],
       status: "confirmed",
       summary:
         "Appointment for #{deal_properties["first_name"]} #{deal_properties["last_name"]}—#{latest_solar_consultation.engagement["activityType"]}",
       start: %GoogleApi.Calendar.V3.Model.EventDateTime{
         dateTime:
           latest_solar_consultation.metadata["startTime"] |> DateTime.from_unix!(:millisecond),
         timeZone: "America/Denver"
       },
       created: DateTime.utc_now()
     }}
  end

  def new(
        %{properties: _deal_properties},
        %{} = _contact_owner,
        %{} = _deal_owner,
        [] = _solar_consultations
      ) do
    {:error, "Missing solar consultations"}
  end

  def new(
        %{properties: _deal_properties},
        %{} = _contact_owner,
        nil = _deal_owner,
        [_head | _tail] = _solar_consultations
      ) do
    {:error, "Missing deal owner"}
  end

  def new(
        %{properties: _deal_properties},
        nil = _contact_owner,
        %{} = _deal_owner,
        [_head | _tail] = _solar_consultations
      ) do
    {:error, "Missing contact owner"}
  end

  def new(
        %{properties: _deal_properties},
        nil = _contact_owner,
        nil = _deal_owner,
        [_head | _tail] = _solar_consultations
      ) do
    {:error, "Missing deal and contact owner"}
  end

  def new(
        %{properties: _deal_properties},
        nil = _contact_owner,
        nil = _deal_owner,
        [] = _solar_consultations
      ) do
    {:error, "Missing deal and contact owner and solar consultations"}
  end
end
