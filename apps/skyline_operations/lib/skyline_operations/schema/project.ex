defmodule SkylineOperations.Project do
  use Ecto.Schema

  embedded_schema do
    field(:hubspot_deal_id, :string)
    field(:netsuite_customer_id, :string)
    field(:netsuite_design_completed_date, :string)
    field(:netsuite_inspection_completed_date, :string)
    field(:netsuite_install_completed_date, :string)
    field(:netsuite_net_metering_pto_completed_date, :string)
    field(:netsuite_nma_permitting_completed_date, :string)
    field(:netsuite_project_id, :string)
    field(:netsuite_project_stage, :string)
    field(:netsuite_project_status, :string)
    field(:netsuite_project_substage, :string)
    field(:netsuite_site_survey_completed_date, :string)
    field(:netsuite_system_on_completed_date, :string)
    field(:netsuite_on_hold_reason, :string)
    field(:netsuite_cancellation_reason, :string)
    field(:netsuite_on_hold_comment, :string)
  end
end
