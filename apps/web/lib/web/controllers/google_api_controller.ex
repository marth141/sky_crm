defmodule Web.GoogleApiController do
  use Web, :controller
  import Ecto.Query

  def inspect(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
    respond_ok(conn)
  end

  @doc """
  For looking up utility, state, and project manager in Org Tracker sheet
  """
  def lookup_utility_from_name(conn, params) do
    %{"name" => name} = params

    try do
      [
        %{
          custentity_bb_utility_company: custentity_bb_utility_company,
          custentity_bb_project_manager_employee: custentity_bb_project_manager_employee,
          custentity_bb_project_location: custentity_bb_project_location
        }
        | []
      ] =
        Repo.all(
          from(p in NetsuiteApi.Project,
            where: ilike(p.custentity_bb_home_owner_name_text, ^(name |> String.trim()))
          )
        )

      %NetsuiteApi.UtilityCompany{name: utility} =
        Repo.get_by!(NetsuiteApi.UtilityCompany,
          netsuite_utility_company_id: custentity_bb_utility_company
        )

      %{firstname: employee_first_name, lastname: employee_last_name} =
        try do
          Repo.get_by!(NetsuiteApi.Employee,
            netsuite_employee_id: custentity_bb_project_manager_employee
          )
        rescue
          _e in Ecto.NoResultsError ->
            %{firstname: nil, lastname: nil}

          _e in ArgumentError ->
            %{firstname: nil, lastname: nil}
        end

      location =
        SkylineOperations.NetsuiteProjectLocationsDictionary.get()[custentity_bb_project_location]

      employee_name =
        if(is_nil(employee_first_name) && is_nil(employee_last_name),
          do: nil,
          else: employee_first_name <> " " <> employee_last_name
        )

      respond_ok(conn, %{
        "utility" => utility,
        "project_manager" => employee_name,
        "project_location" => location
      })
    rescue
      _e in MatchError ->
        %{
          custentity_bb_utility_company: nil,
          custentity_bb_project_manager_employee: nil,
          custentity_bb_install_state: nil
        }
    end
  end

  defp respond_ok(conn, body) do
    json(conn, %{status: :ok, body: body})
  end

  defp respond_ok(conn) do
    json(conn, %{status: :ok})
  end
end
