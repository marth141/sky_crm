defmodule SkylineOperations.NMADocumentSender do
  use GenServer
  import Ecto.Query

  # GenServer (Functions)

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      [],
      name: __MODULE__
    )
  end

  # GenServer (Callbacks)

  def init(_opts) do
    {:ok, %{last_refresh: nil}, {:continue, :init}}
  end

  def handle_continue(:init, state) do
    case Application.get_env(:netsuite_api, :env) do
      :dev ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :test ->
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}

      :prod ->
        schedule_poll(1)
        {:noreply, %{state | last_refresh: DateTime.utc_now()}}
    end
  end

  def handle_info(:refresh_cache, state) do
    refresh_cache()
    {:noreply, %{state | last_refresh: DateTime.utc_now()}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def refresh_cache() do
    # get_one_project()
    get_projects_onboarded_today()
    |> make_doc_jobs()
    |> Enum.map(fn job_arg ->
      SkylineOperations.Jobs.CreateNMAPandadocAndUpdateNetsuite.new(job_arg)
      |> Oban.insert!()
    end)

    IO.puts("\n \n ======= NMA Documents Sent Refreshed ======= \n \n")
    schedule_poll(30)
    :ok
  end

  def make_doc_jobs(projects) when is_list(projects) do
    projects
    |> Enum.map(fn %NetsuiteApi.Project{} = project ->
      nma_template_ids = SkylineOperations.PandaDocTemplates.determine_pandadocs_template(project)

      nma_template_ids
      |> Enum.map(fn %SkylineOperations.SkylinePandadocDefiniton{
                       id: template_id,
                       type: document_type
                     } ->
        pandadoc_data =
          SkylineOperations.PandaDocTemplates.shotgun_fill_pandadoc_template(
            template_id,
            document_type,
            project
          )

        %{
          "project" => project |> Map.from_struct() |> Map.delete(:__meta__),
          "pandadoc_data" => pandadoc_data
        }
      end)
    end)
    |> List.flatten()
  end

  def get_projects_onboarded_today() do
    today = TimeApi.today() |> Timex.format!("{M}/{D}/{YYYY}")

    Repo.all(
      from(p in NetsuiteApi.Project,
        # select: %{
        #   "onboarding_date" => p.custentity_actgrp_133_end_date,
        #   "nma_automation_ran?" => p.custentity_skl_auto_created_nma_document
        # },
        # where:
        #   not is_nil(p.custentity_actgrp_133_end_date) and
        #     not is_nil(p.custentity_skl_auto_created_nma_document)
        where:
          p.custentity_actgrp_133_end_date == ^today and
            p.custentity_skl_auto_created_nma_document == "F"
      )
    )
  end

  def get_one_project() do
    # where: and p.netsuite_project_id == 67200

    Repo.all(
      from(p in NetsuiteApi.Project,
        where: p.netsuite_project_id == 225_365,
        limit: 1
      )
    )
  end

  defp schedule_poll(minutes) do
    Process.send_after(self(), :refresh_cache, :timer.minutes(minutes))
  end
end
