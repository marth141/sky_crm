defmodule Web.Router do
  use Web, :router

  import Web.UserAuth
  import Web.Authorization
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {Web.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/a", Web do
    pipe_through([:browser, :require_authenticated_user, :require_admin])

    live("/users", UserLive.Index, :index)
    live("/users/new", UserLive.Index, :add_user)
    live("/users/:id/edit", UserLive.Index, :edit)

    live("/users/:id", UserLive.Show, :show)
    live("/users/:id/show/edit", UserLive.Show, :edit)

    live_dashboard("/live_dashboard", metrics: Web.Telemetry)

    live("/user_roles", RoleLive.Index, :index)
    live("/user_roles/new", RoleLive.Index, :new)
    live("/user_roles/:id/edit", RoleLive.Index, :edit)

    live("/user_roles/:id", RoleLive.Show, :show)
    live("/user_roles/:id/show/edit", RoleLive.Show, :edit)

    live("/test", TestLive.Index, :index)
    live("/skyline_oban/live", SkylineObanLive.Index, :index)
    live("/skyline_oban/live/:id", SkylineObanLive.Show, :show)
    live("/skyline_oban/static/", SkylineObanStaticLive.Index, :index)
    live("/skyline_oban/retryable/", SkylineObanRetryableLive.Index, :index)
    live("/skyline_oban/available/", SkylineObanAvailableLive.Index, :index)
    live("/skyline_oban/executing/", SkylineObanExecutingLive.Index, :index)
    live("/skyline_oban/cancelled/", SkylineObanCancelledLive.Index, :index)
    live("/skyline_oban/discarded/", SkylineObanDiscardedLive.Index, :index)
    live("/operations/installs", OperationsMonthlyInstallForecastLive.Index, :index)
    live("/it/employees", EmployeesLive.Index, :index)
    live("/it/employees/:id/edit", EmployeesLive.Index, :edit)
    live("/it/employees/new", EmployeesLive.Index, :new)
    live("/it/equipment", EquipmentLive.Index, :index)

    live("/netsuite", NetsuiteApiLive.Index, :index)

    get "/auth/microsoft", MicrosoftOauthController, :index
    get "/hubspot", HubspotOauthController, :index
  end

  scope "/", Web do
    pipe_through([:browser, :redirect_if_user_is_authenticated])
    get "/auth/:provider", UserOauthController, :request
    get "/auth/:provider/callback", UserOauthController, :callback

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/login", UserSessionController, :new)
    post("/users/login", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", Web do
    pipe_through([:browser, :require_authenticated_user])

    live("/", PageLive, :index)

    live("/users/profile", UserLive.Profile, :show)
    live("/users/account_settings", UserLive.AccountSettings, :show)

    delete("/users/logout", UserSessionController, :delete)
    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings/update_password", UserSettingsController, :update_password)
    put("/users/settings/update_email", UserSettingsController, :update_email)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)

    live("/map", MapLive.Index, :index)
  end

  scope "/", Web do
    pipe_through([:browser])

    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :confirm)
  end

  scope "/", Web do
    pipe_through([:api])

    post(
      "/hookmon/send_rep_contract_signed_message",
      HookmonController,
      :send_rep_contract_signed_message
    )

    post(
      "/hookmon/send_finance_contract_signed_message",
      EverBrightController,
      :send_finance_contract_signed_message
    )

    post(
      "/hookmon/create_sighten_site_from_hubspot_deal",
      HookmonController,
      :create_sighten_site_from_hubspot_deal
    )

    post(
      "/hookmon/create_skysupport_calendar_event_from_hubspot_deal",
      HookmonController,
      :create_skysupport_calendar_event_from_hubspot_deal
    )

    post(
      "/hookmon/handle_sighten_contract_status_change",
      HookmonController,
      :handle_sighten_contract_status_change
    )

    post(
      "/hookmon/create_netsuite_customer_from_hubspot_deal",
      HookmonController,
      :create_netsuite_customer_from_hubspot_deal
    )

    post(
      "/hookmon/send_site_survey_completed_from_hubspot_to_netsuite",
      HookmonController,
      :send_site_survey_completed_from_hubspot_to_netsuite
    )

    post(
      "/hookmon/handle_hubspot_ticket",
      HookmonController,
      :handle_hubspot_ticket
    )

    post(
      "/hookmon/netsuite_user_event",
      NetsuiteUserEventController,
      :process_changes
    )

    ## Testing Routes

    post(
      "/hookmon/inspect",
      HookmonController,
      :inspect
    )

    post(
      "/hookmon/netsuite",
      HookmonController,
      :netsuite
    )

    post(
      "/hookmon/sitecapture",
      HookmonController,
      :sitecapture
    )

    # For Org tracker sheet
    post "/google", GoogleApiController, :lookup_utility_from_name

    post "/hookmon/nps_score", NpsScoreController, :send_to_netsuite

    post "/zenefits", ZenefitsWebhookController, :inspect
  end
end
