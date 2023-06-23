defmodule Web.HookmonControllerTest do
  @moduledoc """
  This module is used to test most of the things that go on
  in the Web.HookmonController
  """

  use Web, :controller

  @doc """
  Passing
  """
  @doc since: "0.5.20"
  def test_send_rep_contract_signed_message() do
    %{body_params: params} =
      fixture_incoming_sighten_contract(
        "70e49050-4cb0-49f8-8120-0e555745e2ae",
        "9f8e1de2-2181-47a0-9be0-4030bab16364"
      )

    contract_sub_tasks = params["sub_tasks"] |> List.first()

    if contract_sub_tasks["status"] == "COMP" do
      IO.puts("🙌 Completed Contract! 🙌")

      with {:ok, _status} <- SkylineProposals.send_rep_contract_signed_message(params) do
        :ok
      else
        {:error, _error} ->
          IO.puts("Error while Sending Contract Signed Message")
          :error
      end
    else
      :ok
    end
  end

  @doc """
  Passes
  """
  @doc since: "0.5.20"
  def test_create_sighten_site_from_hubspot_deal() do
    conn = fixture_incoming_hubspot_deal()

    with {:ok, sighten_resp} <-
           SkylineSales.create_sighten_site_from_hubspot_deal(conn.body_params) do
      {:ok, sighten_resp}
    else
      {:error, error} ->
        IO.puts("Error while creating Sighten site")
        {:error, error}
    end
  end

  @doc """
  Passes
  """
  @doc since: "0.5.20"
  def test_create_skysupport_calendar_event_from_hubspot_deal() do
    conn = fixture_incoming_hubspot_deal()

    with {:ok, _resp} <-
           SkylineProposals.create_skysupport_solar_consultation_calendar_event_from_hubspot_deal(
             conn.body_params
           ) do
      {:ok, "Created Sky Support Solar Consultation Calendar Event"}
    else
      {:error, error} ->
        IO.puts("Error while creating Sky Support Solar Consultation Event")
        {:error, error}
    end
  end

  @doc """
  Passes
  """
  @doc since: "0.5.20"
  def test_handle_sighten_contract_status_change() do
    %{body_params: params} =
      fixture_incoming_sighten_contract(
        "70e49050-4cb0-49f8-8120-0e555745e2ae",
        "9f8e1de2-2181-47a0-9be0-4030bab16364"
      )

    contract_sub_tasks = params["sub_tasks"] |> List.first()

    if contract_sub_tasks["status"] == "COMP" do
      IO.puts("🙌 Completed Contract! 🙌")
      SkylineProposals.handle_sighten_contract_status_change(params)
    else
      {:ok, "Not completed"}
    end
  end

  @doc """
  Passes
  """
  @doc since: "0.5.20"
  def test_create_netsuite_customer_from_hubspot_deal do
    %{body_params: params} = fixture_incoming_hubspot_deal()

    {:ok, _job} = SkylineOperations.create_netsuite_customer_from_hubspot_deal(params)
  end

  @doc """
  This should take in the Hubspot fixture, find the Netsuite project associated
  with it's Hubspot Deal ID, and

  Passes
  """
  @doc since: "0.5.20"
  def test_send_site_survey_completed_from_hubspot_to_netsuite() do
    %{body_params: params} = fixture_incoming_hubspot_deal()

    {:ok, _job} = SkylineOperations.send_site_survey_completed_from_hubspot_to_netsuite(params)
  end

  def fixture_incoming_sighten() do
    %Plug.Conn{
      body_params: %{
        "previous_stage_id" => "some previous id",
        "previous_stage_name" => "some previous stage name",
        "site_owned_by_organization" => "some site owning org",
        "stage_id" => "some stage id",
        "site_id" => "70e49050-4cb0-49f8-8120-0e555745e2ae",
        "stage_name" =>
          "Trigger—Send Newest Proposal to Hubspot and set Deal Stage to \"Design Complete - Pending Review\""
      }
    }
  end

  def fixture_incoming_copper() do
    %Plug.Conn{
      body_params: %{
        "event" => "update",
        "ids" => [25_015_039],
        "key" => "copper_notifications",
        "secret" => "test_hook",
        "subscription_id" => 197_233,
        "type" => "opportunity",
        "updated_attributes" => %{
          "custom_fields" => %{"158002" => [1_629_093_600, 1_625_443_200]},
          "stage" => ["previous", "9 System On"],
          "status" => ["previous", "Lost"],
          "loss_reason_id" => ["previous", "716_161"]
        }
      }
    }
  end

  def fixture_incoming_sighten_contract(sighten_site_id, sighten_quote_id) do
    %Plug.Conn{
      body_params: %{
        "assigned_to" => %{
          "email" => "@org",
          "first_name" => "Nate",
          "last_name" => "Casados",
          "organization" => "6502f3c3-0dbd-4623-842e-35f3639bddb6",
          "organization_name" => "Org",
          "uuid" => "47531c3e-a4d4-4354-be26-6aee30c21fd0"
        },
        "comments" => [
          %{
            "comment" =>
              "Installation Agreement - Signed.pdf was uploaded to sub task Installation Agreement from Docusign.",
            "comment_type" => "AUTO",
            "commenter_id" => "cfece046-65fc-48c5-9811-08e8b941d8ef",
            "commentor" => "sightenbot@sighten.io",
            "commentor_first_name" => "Sighten",
            "commentor_last_name" => "Bot",
            "last_updated" => nil,
            "private" => false,
            "thread" => nil,
            "timestamp" => "2021-11-09T18:46:04.661432Z",
            "uuid" => "1c1e4024-a797-4a9e-b204-da1bdcfe3643"
          },
          %{
            "comment" =>
              "N re-sent Org GoodLeap Installation Agreement.pdf for signature for sub task Installation Agreement.",
            "comment_type" => "AUTO",
            "commenter_id" => "cfece046-65fc-48c5-9811-08e8b941d8ef",
            "commentor" => "sightenbot@sighten.io",
            "commentor_first_name" => "Sighten",
            "commentor_last_name" => "Bot",
            "last_updated" => nil,
            "private" => false,
            "thread" => nil,
            "timestamp" => "2021-11-09T18:44:22.156398Z",
            "uuid" => "fa7c7487-15f9-442b-940a-5730909b31b7"
          },
          %{
            "comment" =>
              "N sent Org GoodLeap Installation Agreement.pdf for signature for sub task Installation Agreement.",
            "comment_type" => "AUTO",
            "commenter_id" => "cfece046-65fc-48c5-9811-08e8b941d8ef",
            "commentor" => "sightenbot@sighten.io",
            "commentor_first_name" => "Sighten",
            "commentor_last_name" => "Bot",
            "last_updated" => nil,
            "private" => false,
            "thread" => nil,
            "timestamp" => "2021-11-09T18:33:52.694365Z",
            "uuid" => "6cddc874-89db-4220-ac90-cd5889d5d0a8"
          },
          %{
            "comment" =>
              "N generated Org GoodLeap Installation Agreement.pdf for sub task Installation Agreement.",
            "comment_type" => "AUTO",
            "commenter_id" => "cfece046-65fc-48c5-9811-08e8b941d8ef",
            "commentor" => "sightenbot@sighten.io",
            "commentor_first_name" => "Sighten",
            "commentor_last_name" => "Bot",
            "last_updated" => nil,
            "private" => false,
            "thread" => nil,
            "timestamp" => "2021-11-09T18:33:48.814670Z",
            "uuid" => "21c52100-e099-418c-8e39-3a532e31c7f8"
          }
        ],
        "date_updated" => "2021-11-09T18:33:02.733634Z",
        "description" => "",
        "milestone" => "7cabc21a-8ab1-4313-9551-98cf708b2be1",
        "milestone_definition" => "083ced64-94ff-450b-b562-829a7d90f7bf",
        "name" => "Installation Agreement",
        "quote" => sighten_quote_id,
        "site" => sighten_site_id,
        "status" => "INPROG",
        "sub_tasks" => [
          %{
            "category" => "DOCUMENT",
            "data" => %{
              "documents" => [
                %{
                  "creation_type" => "GENERATED",
                  "date_created" => "2021-11-09T18:33:48.781368Z",
                  "document_group" => "8e66e8a0-f48c-4c60-bf48-f34f49cec193",
                  "document_type" => "HIC",
                  "name" => "Org GoodLeap Installation Agreement.pdf",
                  "stale" => false,
                  "uuid" => "6aaf0836-afc6-4db7-92ed-cd6224adf528"
                },
                %{
                  "creation_type" => "UPLOADED",
                  "date_created" => "2021-11-09T18:46:03.186927Z",
                  "document_group" => "8e66e8a0-f48c-4c60-bf48-f34f49cec193",
                  "document_type" => "OTH",
                  "name" => "Installation Agreement - Signed.pdf",
                  "stale" => false,
                  "uuid" => "3ff797b2-5dc4-4597-bf5b-e39daa74635d"
                }
              ],
              "envelopes" => [
                %{
                  "date_sent" => "2021-11-09T18:44:22.118248Z",
                  "date_signed" => "2021-11-09T18:46:01.838286Z",
                  "date_voided" => nil,
                  "document_group" => "8e66e8a0-f48c-4c60-bf48-f34f49cec193",
                  "name" => "GoodLeap Loan Contract",
                  "resource_id" => "3af20a7f-ed50-4f1f-9ade-2bd6330d6665",
                  "status" => "COMP",
                  "task_action_alias" => "DSN",
                  "uuid" => "c082fa64-a0e7-4120-ae7c-496787d89efb"
                }
              ]
            },
            "document_status" => "SIGN",
            "instructions" => nil,
            "label" => "Installation Agreement",
            "required" => false,
            "signers" => [
              %{
                "can_update" => true,
                "contact_signer" => "f36c8dc5-be14-4cd5-8473-6c7ce6e72b7d",
                "created_by" => "47531c3e-a4d4-4354-be26-6aee30c21fd0",
                "date_created" => "2021-11-09T18:33:02.811724Z",
                "date_declined" => nil,
                "date_sent" => "2021-11-09T18:44:22.199310Z",
                "date_signed" => "2021-11-09T18:46:01.279705Z",
                "date_updated" => "2021-11-09T18:46:01.279823Z",
                "date_voided" => nil,
                "email" => "@org",
                "first_name" => "Nate",
                "last_name" => "Casados",
                "legal_contact_signer" => nil,
                "modified_by" => "47531c3e-a4d4-4354-be26-6aee30c21fd0",
                "order" => 1,
                "signer_type" => "H",
                "status" => "COMP",
                "user_signer" => nil,
                "uuid" => "1cd8c3ee-cfc7-4a4d-98ba-47ed0433fb70"
              }
            ],
            "status" => "COMP",
            "uuid" => "dad31235-5c9e-4edd-aa9c-c78fefbeb7b0"
          }
        ],
        "task_definition" => "6e35f117-a8f3-4ec3-a2f9-a6422e49804d",
        "uuid" => "52fc0c6a-07f6-49dd-a945-60599226d5ea"
      }
    }
  end

  @doc """
  This thing is the shape of what comes in from a hubspot workflow.
  Still becomes a deal, I don't think there are any that depend on contacts.
  """
  def fixture_incoming_hubspot_deal do
    %Plug.Conn{
      body_params: %{
        "isDeleted" => false,
        "objectId" => 5_568_776_798,
        "objectType" => "DEAL",
        "objectTypeId" => "0-3",
        "portalId" => 14_557_302,
        "properties" => %{
          "hs_createdate" => %{
            "source" => "CONTACTS",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_625_003_881_362,
            "updatedByUserId" => 18_622_744,
            "value" => "1625003881362",
            "versions" => [
              %{
                "name" => "hs_createdate",
                "requestId" => "0d3c4cfe-3c43-4a87-afb3-cab0957819e7",
                "source" => "CONTACTS",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_362,
                "updatedByUserId" => 18_622_744,
                "value" => "1625003881362"
              }
            ]
          },
          "closed_lost_date" => %{
            "source" => "AUTOMATION_PLATFORM",
            "sourceId" => "enrollmentId:210114302807;actionExecutionIndex:0",
            "timestamp" => 1_641_579_199_253,
            "updatedByUserId" => nil,
            "value" => "1641513600000",
            "versions" => [
              %{
                "name" => "closed_lost_date",
                "source" => "AUTOMATION_PLATFORM",
                "sourceId" => "enrollmentId:210114302807;actionExecutionIndex:0",
                "sourceVid" => [],
                "timestamp" => 1_641_579_199_253,
                "value" => "1641513600000"
              }
            ]
          },
          "trenching_distance" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_635_287_970_927,
            "updatedByUserId" => 18_622_744,
            "value" => "20",
            "versions" => [
              %{
                "name" => "trenching_distance",
                "requestId" => "ea4b51cd-6a5c-4b4b-b01e-a476e93af136",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_635_287_970_927,
                "updatedByUserId" => 18_622_744,
                "value" => "20"
              }
            ]
          },
          "premise_number" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_286_268_009,
            "updatedByUserId" => 18_622_744,
            "value" => "555-555",
            "versions" => [
              %{
                "name" => "premise_number",
                "requestId" => "2fe3211a-b7d9-47a9-8cdf-3c8810f2544f",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_286_268_009,
                "updatedByUserId" => 18_622_744,
                "value" => "555-555"
              }
            ]
          },
          "proposal_battery_model" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_635_794_751_733,
            "updatedByUserId" => nil,
            "value" => "LG Chem RESU10H",
            "versions" => [
              %{
                "name" => "proposal_battery_model",
                "requestId" => "1668a9de-0929-4d12-a72b-e34b7f7a2494",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_635_794_751_733,
                "value" => "LG Chem RESU10H"
              }
            ]
          },
          "notes_last_contacted" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_638_991_856_742,
            "updatedByUserId" => nil,
            "value" => "1638991851066",
            "versions" => [
              %{
                "name" => "notes_last_contacted",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_638_991_856_742,
                "value" => "1638991851066"
              }
            ]
          },
          "cancel_date" => %{
            "source" => "AUTOMATION_PLATFORM",
            "sourceId" => "enrollmentId:210114302807;actionExecutionIndex:2",
            "timestamp" => 1_641_579_203_008,
            "updatedByUserId" => nil,
            "value" => "",
            "versions" => [
              %{
                "name" => "cancel_date",
                "source" => "AUTOMATION_PLATFORM",
                "sourceId" => "enrollmentId:210114302807;actionExecutionIndex:2",
                "sourceVid" => [],
                "timestamp" => 1_641_579_203_008,
                "value" => ""
              }
            ]
          },
          "hs_all_team_ids" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "3251297;3315449",
            "versions" => [
              %{
                "name" => "hs_all_team_ids",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "3251297;3315449"
              }
            ]
          },
          "install_area" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_296_168_485,
            "updatedByUserId" => 18_622_744,
            "value" => "Utah",
            "versions" => [
              %{
                "name" => "install_area",
                "requestId" => "e39376fb-5041-4e2a-9229-f88f4d707dfb",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_296_168_485,
                "updatedByUserId" => 18_622_744,
                "value" => "Utah"
              }
            ]
          },
          "ppw" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "4.386",
            "versions" => [
              %{
                "name" => "ppw",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "4.386"
              }
            ]
          },
          "finance_type" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_635_287_939_806,
            "updatedByUserId" => 18_622_744,
            "value" => "GoodLeap",
            "versions" => [
              %{
                "name" => "finance_type",
                "requestId" => "b91229ae-faac-468c-978e-031857854dd3",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_635_287_939_806,
                "updatedByUserId" => 18_622_744,
                "value" => "GoodLeap"
              }
            ]
          },
          "inverter_count" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_635_794_751_733,
            "updatedByUserId" => nil,
            "value" => "1",
            "versions" => [
              %{
                "name" => "inverter_count",
                "requestId" => "1668a9de-0929-4d12-a72b-e34b7f7a2494",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_635_794_751_733,
                "value" => "1"
              }
            ]
          },
          "street_address" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_384_539_670,
            "updatedByUserId" => 18_622_744,
            "value" => "663 W State St",
            "versions" => [
              %{
                "name" => "street_address",
                "requestId" => "1af592c1-c446-4ccb-b7f8-ce712b3abd07",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_384_539_670,
                "updatedByUserId" => 18_622_744,
                "value" => "663 W State St"
              }
            ]
          },
          "date_sighten_contract_signed" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "1643846400000",
            "versions" => [
              %{
                "name" => "date_sighten_contract_signed",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "1643846400000"
              }
            ]
          },
          "solar_offset" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "72.41275671331465",
            "versions" => [
              %{
                "name" => "solar_offset",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "72.41275671331465"
              }
            ]
          },
          "average_roof_pitch" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "20.0",
            "versions" => [
              %{
                "name" => "average_roof_pitch",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "20.0"
              }
            ]
          },
          "hs_closed_amount_in_home_currency" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_641_579_168_945,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "hs_closed_amount_in_home_currency",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_641_579_168_945,
                "value" => "0"
              }
            ]
          },
          "estimated_monthly_production_average" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "745.4852192499999",
            "versions" => [
              %{
                "name" => "estimated_monthly_production_average",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "745.4852192499999"
              }
            ]
          },
          "utility_company" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_643_054_544_002,
            "updatedByUserId" => 18_622_744,
            "value" => "City of Aspen",
            "versions" => [
              %{
                "name" => "utility_company",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_643_054_544_002,
                "updatedByUserId" => 18_622_744,
                "value" => "City of Aspen"
              }
            ]
          },
          "hs_is_closed_won" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_641_579_168_945,
            "updatedByUserId" => nil,
            "value" => "false",
            "versions" => [
              %{
                "name" => "hs_is_closed_won",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_641_579_168_945,
                "value" => "false"
              }
            ]
          },
          "hs_user_ids_of_all_owners" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "18622744;24104823;27890528",
            "versions" => [
              %{
                "name" => "hs_user_ids_of_all_owners",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "18622744;24104823;27890528"
              }
            ]
          },
          "hubspot_owner_id" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "70635039",
            "versions" => [
              %{
                "name" => "hubspot_owner_id",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "70635039"
              }
            ]
          },
          "base_ppw" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_286_370_689,
            "updatedByUserId" => 18_622_744,
            "value" => "3.85",
            "versions" => [
              %{
                "name" => "base_ppw",
                "requestId" => "13a56945-a7a2-4bc7-b20d-e0db8f73213b",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_286_370_689,
                "updatedByUserId" => 18_622_744,
                "value" => "3.85"
              }
            ]
          },
          "site_survey_completed" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_642_009_319_887,
            "updatedByUserId" => 18_622_744,
            "value" => "1520899200000",
            "versions" => [
              %{
                "name" => "site_survey_completed",
                "requestId" => "efb2f51c-27a0-444b-b359-d8d5f35faf00",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_642_009_319_887,
                "updatedByUserId" => 18_622_744,
                "value" => "1520899200000"
              }
            ]
          },
          "finance_cost" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "3815.78947368421",
            "versions" => [
              %{
                "name" => "finance_cost",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "3815.78947368421"
              }
            ]
          },
          "hs_deal_stage_probability" => %{
            "source" => "CALCULATED",
            "sourceId" => "DealStageProbabilityHandler",
            "timestamp" => 1_641_579_169_435,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "hs_deal_stage_probability",
                "source" => "CALCULATED",
                "sourceId" => "DealStageProbabilityHandler",
                "sourceVid" => [],
                "timestamp" => 1_641_579_169_435,
                "value" => "0"
              }
            ]
          },
          "proposal_module_size" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "400",
            "versions" => [
              %{
                "name" => "proposal_module_size",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "400"
              }
            ]
          },
          "proposal_inverter_size" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_633_029_530_722,
            "updatedByUserId" => nil,
            "value" => "7600",
            "versions" => [
              %{
                "name" => "proposal_inverter_size",
                "requestId" => "1bf9c32f-d2c6-4b04-8fbd-a488d724999f",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_633_029_530_722,
                "value" => "7600"
              }
            ]
          },
          "time_to_close" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_639_965_058_673,
            "updatedByUserId" => nil,
            "value" => "",
            "versions" => [
              %{
                "name" => "time_to_close",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_639_965_058_673,
                "value" => ""
              }
            ]
          },
          "cancel_reason" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_639_085_127_486,
            "updatedByUserId" => 18_622_744,
            "value" => "Personal Finances",
            "versions" => [
              %{
                "name" => "cancel_reason",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_639_085_127_486,
                "updatedByUserId" => 18_622_744,
                "value" => "Personal Finances"
              }
            ]
          },
          "hubspot_owner_assigneddate" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "1645213842329",
            "versions" => [
              %{
                "name" => "hubspot_owner_assigneddate",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "1645213842329"
              }
            ]
          },
          "copper_opportunity_id" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_634_658_898_706,
            "updatedByUserId" => 18_622_744,
            "value" => "25015039",
            "versions" => [
              %{
                "name" => "copper_opportunity_id",
                "requestId" => "0a736382-ca9b-4ebb-a19f-a4e4731c66cc",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_634_658_898_706,
                "updatedByUserId" => 18_622_744,
                "value" => "25015039"
              }
            ]
          },
          "array_type" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_633_028_732_537,
            "updatedByUserId" => nil,
            "value" => "ROOF_MOUNTED_FIXED",
            "versions" => [
              %{
                "name" => "array_type",
                "requestId" => "3cd2445e-ecfa-4016-8c53-2ce6b06f0379",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_633_028_732_537,
                "value" => "ROOF_MOUNTED_FIXED"
              }
            ]
          },
          "closed_lost_reason" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_639_084_583_669,
            "updatedByUserId" => 18_622_744,
            "value" => "Accidentally Inquired",
            "versions" => [
              %{
                "name" => "closed_lost_reason",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_639_084_583_669,
                "updatedByUserId" => 18_622_744,
                "value" => "Accidentally Inquired"
              }
            ]
          },
          "dealstage" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_641_579_168_860,
            "updatedByUserId" => 8_514_594,
            "value" => "closedlost",
            "versions" => [
              %{
                "name" => "dealstage",
                "requestId" => "8ccb4d0e-7bd7-4581-a06f-29b68254aa53",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_641_579_168_860,
                "updatedByUserId" => 8_514_594,
                "value" => "closedlost"
              }
            ]
          },
          "adders_ppw__" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "-0.099965",
            "versions" => [
              %{
                "name" => "adders_ppw__",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "-0.099965"
              }
            ]
          },
          "createdate" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_625_003_881_362,
            "updatedByUserId" => 18_622_744,
            "value" => "1625003874585",
            "versions" => [
              %{
                "name" => "createdate",
                "requestId" => "0d3c4cfe-3c43-4a87-afb3-cab0957819e7",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_362,
                "updatedByUserId" => 18_622_744,
                "value" => "1625003874585"
              }
            ]
          },
          "hs_is_closed" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_639_084_583_669,
            "updatedByUserId" => nil,
            "value" => "true",
            "versions" => [
              %{
                "name" => "hs_is_closed",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_639_084_583_669,
                "value" => "true"
              }
            ]
          },
          "city" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_384_539_670,
            "updatedByUserId" => 18_622_744,
            "value" => "Pleasant Grove",
            "versions" => [
              %{
                "name" => "city",
                "requestId" => "1af592c1-c446-4ccb-b7f8-ce712b3abd07",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_384_539_670,
                "updatedByUserId" => 18_622_744,
                "value" => "Pleasant Grove"
              }
            ]
          },
          "proposal_array_count" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_633_028_732_537,
            "updatedByUserId" => nil,
            "value" => "1",
            "versions" => [
              %{
                "name" => "proposal_array_count",
                "requestId" => "3cd2445e-ecfa-4016-8c53-2ce6b06f0379",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_633_028_732_537,
                "value" => "1"
              }
            ]
          },
          "hs_deal_stage_probability_shadow" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_641_579_168_945,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "hs_deal_stage_probability_shadow",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_641_579_168_945,
                "value" => "0"
              }
            ]
          },
          "site_survey_scheduled" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_632_172_963_063,
            "updatedByUserId" => 8_514_594,
            "value" => "",
            "versions" => [
              %{
                "name" => "site_survey_scheduled",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_632_172_963_063,
                "updatedByUserId" => 8_514_594,
                "value" => ""
              }
            ]
          },
          "proposal_module_model" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "Hanwha Q CELLS Q.PEAK DUO BLK ML-G10 400",
            "versions" => [
              %{
                "name" => "proposal_module_model",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "Hanwha Q CELLS Q.PEAK DUO BLK ML-G10 400"
              }
            ]
          },
          "hs_analytics_source_data_1" => %{
            "source" => "DEALS",
            "sourceId" => "deal sync triggered by vid=6351",
            "timestamp" => 1_625_003_881_984,
            "updatedByUserId" => nil,
            "value" => "meetings.hubspot.com/drew280",
            "versions" => [
              %{
                "name" => "hs_analytics_source_data_1",
                "source" => "DEALS",
                "sourceId" => "deal sync triggered by vid=6351",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_984,
                "value" => "meetings.hubspot.com/drew280"
              }
            ]
          },
          "contact_owner" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_635_786_859_975,
            "updatedByUserId" => 18_622_744,
            "value" => "65678890",
            "versions" => [
              %{
                "name" => "contact_owner",
                "requestId" => "a64d9e2e-f523-460a-8cce-1915ab841c9f",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_635_786_859_975,
                "updatedByUserId" => 18_622_744,
                "value" => "65678890"
              }
            ]
          },
          "hs_created_by_user_id" => %{
            "source" => "CONTACTS",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_625_003_881_362,
            "updatedByUserId" => 18_622_744,
            "value" => "18622744",
            "versions" => [
              %{
                "name" => "hs_created_by_user_id",
                "requestId" => "0d3c4cfe-3c43-4a87-afb3-cab0957819e7",
                "source" => "CONTACTS",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_362,
                "updatedByUserId" => 18_622_744,
                "value" => "18622744"
              }
            ]
          },
          "notes_last_updated" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_638_991_856_742,
            "updatedByUserId" => nil,
            "value" => "1638991851066",
            "versions" => [
              %{
                "name" => "notes_last_updated",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_638_991_856_742,
                "value" => "1638991851066"
              }
            ]
          },
          "hs_analytics_source" => %{
            "source" => "DEALS",
            "sourceId" => "deal sync triggered by vid=6351",
            "timestamp" => 1_625_003_881_984,
            "updatedByUserId" => nil,
            "value" => "DIRECT_TRAFFIC",
            "versions" => [
              %{
                "name" => "hs_analytics_source",
                "source" => "DEALS",
                "sourceId" => "deal sync triggered by vid=6351",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_984,
                "value" => "DIRECT_TRAFFIC"
              }
            ]
          },
          "proposal_battery_count" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "proposal_battery_count",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "0"
              }
            ]
          },
          "days_to_close" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_639_965_058_673,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "days_to_close",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_639_965_058_673,
                "value" => "0"
              }
            ]
          },
          "proposal_inverter_model" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_633_029_530_722,
            "updatedByUserId" => nil,
            "value" => "SolarEdge StorEdge 7.6",
            "versions" => [
              %{
                "name" => "proposal_inverter_model",
                "requestId" => "1bf9c32f-d2c6-4b04-8fbd-a488d724999f",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_633_029_530_722,
                "value" => "SolarEdge StorEdge 7.6"
              }
            ]
          },
          "hs_num_associated_deal_splits" => %{
            "source" => "CALCULATED",
            "sourceId" => "RollupProperties",
            "timestamp" => 1_625_003_882_051,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "hs_num_associated_deal_splits",
                "source" => "CALCULATED",
                "sourceId" => "RollupProperties",
                "sourceVid" => [],
                "timestamp" => 1_625_003_882_051,
                "value" => "0"
              }
            ]
          },
          "total_amount" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "26315.78947368421",
            "versions" => [
              %{
                "name" => "total_amount",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "26315.78947368421"
              }
            ]
          },
          "hs_is_deal_split" => %{
            "source" => "MIGRATION",
            "sourceId" => "RecalculateCalculatedPropertiesHelper",
            "timestamp" => 1_630_659_205_906,
            "updatedByUserId" => nil,
            "value" => "false",
            "versions" => [
              %{
                "name" => "hs_is_deal_split",
                "source" => "MIGRATION",
                "sourceId" => "RecalculateCalculatedPropertiesHelper",
                "sourceVid" => [],
                "timestamp" => 1_630_659_205_906,
                "value" => "false"
              }
            ]
          },
          "project_manager" => %{
            "source" => "AUTOMATION_PLATFORM",
            "sourceId" => "enrollmentId:206100785511;actionExecutionIndex:0",
            "timestamp" => 1_640_821_746_026,
            "updatedByUserId" => nil,
            "value" => "133699987",
            "versions" => [
              %{
                "name" => "project_manager",
                "source" => "AUTOMATION_PLATFORM",
                "sourceId" => "enrollmentId:206100785511;actionExecutionIndex:0",
                "sourceVid" => [],
                "timestamp" => 1_640_821_746_026,
                "value" => "133699987"
              }
            ]
          },
          "hs_lastmodifieddate" => %{
            "source" => "CALCULATED",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => nil,
            "value" => "1645213842329",
            "versions" => [
              %{
                "name" => "hs_lastmodifieddate",
                "source" => "CALCULATED",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "value" => "1645213842329"
              }
            ]
          },
          "netsuite_project_synced" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_634_668_561_824,
            "updatedByUserId" => 18_622_744,
            "value" => "false",
            "versions" => [
              %{
                "name" => "netsuite_project_synced",
                "requestId" => "d2d801c7-3891-4f54-ad02-f29ddc575f24",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_634_668_561_824,
                "updatedByUserId" => 18_622_744,
                "value" => "false"
              }
            ]
          },
          "hs_manual_forecast_category" => %{
            "source" => "AUTOMATION_PLATFORM",
            "sourceId" => "enrollmentId:196802085532;actionExecutionIndex:1",
            "timestamp" => 1_639_084_605_120,
            "updatedByUserId" => nil,
            "value" => "OMIT",
            "versions" => [
              %{
                "name" => "hs_manual_forecast_category",
                "source" => "AUTOMATION_PLATFORM",
                "sourceId" => "enrollmentId:196802085532;actionExecutionIndex:1",
                "sourceVid" => [],
                "timestamp" => 1_639_084_605_120,
                "value" => "OMIT"
              }
            ]
          },
          "finance_fees_ppw" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "0.635965",
            "versions" => [
              %{
                "name" => "finance_fees_ppw",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "0.635965"
              }
            ]
          },
          "zip" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_636_744_744_088,
            "updatedByUserId" => 18_622_744,
            "value" => "84062",
            "versions" => [
              %{
                "name" => "zip",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_636_744_744_088,
                "updatedByUserId" => 18_622_744,
                "value" => "84062"
              }
            ]
          },
          "num_contacted_notes" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_638_991_856_742,
            "updatedByUserId" => nil,
            "value" => "19",
            "versions" => [
              %{
                "name" => "num_contacted_notes",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_638_991_856_742,
                "value" => "19"
              }
            ]
          },
          "system_production_in_first_year" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "8945.822631",
            "versions" => [
              %{
                "name" => "system_production_in_first_year",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "8945.822631"
              }
            ]
          },
          "adders_ppw" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "0.536",
            "versions" => [
              %{
                "name" => "adders_ppw",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "0.536"
              }
            ]
          },
          "closedate" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_639_965_058_673,
            "updatedByUserId" => 8_514_594,
            "value" => "",
            "versions" => [
              %{
                "name" => "closedate",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_639_965_058_673,
                "updatedByUserId" => 8_514_594,
                "value" => ""
              }
            ]
          },
          "amount" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "26316.0",
            "versions" => [
              %{
                "name" => "amount",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "26316.0"
              }
            ]
          },
          "proposal_url" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "https://engine.sighten.io/proposal/f4067915-5c20-4431-9b1e-68911837b740",
            "versions" => [
              %{
                "name" => "proposal_url",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" =>
                  "https://engine.sighten.io/proposal/f4067915-5c20-4431-9b1e-68911837b740"
              }
            ]
          },
          "install_date" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_631_295_604_948,
            "updatedByUserId" => nil,
            "value" => "1596672000000",
            "versions" => [
              %{
                "name" => "install_date",
                "requestId" => "76059676-1f97-43aa-98e5-dfb9a268dc9b",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_631_295_604_948,
                "value" => "1596672000000"
              }
            ]
          },
          "adders" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_635_789_880_704,
            "updatedByUserId" => 18_622_744,
            "value" =>
              "Critter Guard;LED;Upsized Inverter;Battery (16kW);Ground Mount;EV Charger;Extended Inverter Warranty;Cashback;Battery (10kW);NONE;Extended Production Monitoring;GM Trenching;Main Panel Upgrade;New Roof;Panel Skirts;Panel Tilt;Premium Modules;Smart Therm;Premium Inverter (SE HUB);Tree Trimming;Trenching (Dirt);Trenching (Other);Trenching (Concrete);Roof (Concrete/Tile)",
            "versions" => [
              %{
                "name" => "adders",
                "requestId" => "8484fb4e-f020-4a7e-b9ce-6b73d148be30",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_635_789_880_704,
                "updatedByUserId" => 18_622_744,
                "value" =>
                  "Critter Guard;LED;Upsized Inverter;Battery (16kW);Ground Mount;EV Charger;Extended Inverter Warranty;Cashback;Battery (10kW);NONE;Extended Production Monitoring;GM Trenching;Main Panel Upgrade;New Roof;Panel Skirts;Panel Tilt;Premium Modules;Smart Therm;Premium Inverter (SE HUB);Tree Trimming;Trenching (Dirt);Trenching (Other);Trenching (Concrete);Roof (Concrete/Tile)"
              }
            ]
          },
          "hs_closed_amount" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_641_579_168_945,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "hs_closed_amount",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_641_579_168_945,
                "value" => "0"
              }
            ]
          },
          "sales_area" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_384_539_670,
            "updatedByUserId" => 18_622_744,
            "value" => "Utah County",
            "versions" => [
              %{
                "name" => "sales_area",
                "requestId" => "1af592c1-c446-4ccb-b7f8-ce712b3abd07",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_384_539_670,
                "updatedByUserId" => 18_622_744,
                "value" => "Utah County"
              }
            ]
          },
          "sighten_site_id" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_643_911_060_130,
            "updatedByUserId" => 18_622_744,
            "value" => "70e49050-4cb0-49f8-8120-0e555745e2ae",
            "versions" => [
              %{
                "name" => "sighten_site_id",
                "requestId" => "6afe1acc-8204-4606-8c05-47fa33166d2e",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_643_911_060_130,
                "updatedByUserId" => 18_622_744,
                "value" => "70e49050-4cb0-49f8-8120-0e555745e2ae"
              }
            ]
          },
          "panel_tilt" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "20.0",
            "versions" => [
              %{
                "name" => "panel_tilt",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "20.0"
              }
            ]
          },
          "hs_latest_meeting_activity" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_637_270_812_396,
            "updatedByUserId" => nil,
            "value" => "",
            "versions" => [
              %{
                "name" => "hs_latest_meeting_activity",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_637_270_812_396,
                "value" => ""
              }
            ]
          },
          "notes_next_activity_date" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_637_270_812_396,
            "updatedByUserId" => nil,
            "value" => "",
            "versions" => [
              %{
                "name" => "notes_next_activity_date",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_637_270_812_396,
                "value" => ""
              }
            ]
          },
          "num_notes" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_638_991_856_742,
            "updatedByUserId" => nil,
            "value" => "28",
            "versions" => [
              %{
                "name" => "num_notes",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_638_991_856_742,
                "value" => "28"
              }
            ]
          },
          "hs_forecast_amount" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_639_084_631_256,
            "updatedByUserId" => nil,
            "value" => "0.00",
            "versions" => [
              %{
                "name" => "hs_forecast_amount",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_639_084_631_256,
                "value" => "0.00"
              }
            ]
          },
          "hs_sales_email_last_replied" => %{
            "source" => "ENGAGEMENTS",
            "sourceId" => "ObjectPropertyUpdater",
            "timestamp" => 1_626_102_213_247,
            "updatedByUserId" => nil,
            "value" => "1626102199000",
            "versions" => [
              %{
                "name" => "hs_sales_email_last_replied",
                "source" => "ENGAGEMENTS",
                "sourceId" => "ObjectPropertyUpdater",
                "sourceVid" => [],
                "timestamp" => 1_626_102_213_247,
                "value" => "1626102199000"
              }
            ]
          },
          "country" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_207_254_340,
            "updatedByUserId" => 18_622_744,
            "value" => "US",
            "versions" => [
              %{
                "name" => "country",
                "requestId" => "0249ecc2-ce68-4c40-a513-d633c2275b82",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_207_254_340,
                "updatedByUserId" => 18_622_744,
                "value" => "US"
              }
            ]
          },
          "proposal_created_date" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "1643846400000",
            "versions" => [
              %{
                "name" => "proposal_created_date",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "1643846400000"
              }
            ]
          },
          "hs_projected_amount_in_home_currency" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_641_579_169_435,
            "updatedByUserId" => nil,
            "value" => "0.0",
            "versions" => [
              %{
                "name" => "hs_projected_amount_in_home_currency",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_641_579_169_435,
                "value" => "0.0"
              }
            ]
          },
          "hoa___name___contact" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_643_063_069_896,
            "updatedByUserId" => 18_622_744,
            "value" => "Alice HOA you know what I'm saying?",
            "versions" => [
              %{
                "name" => "hoa___name___contact",
                "requestId" => "32457b61-b38c-42e5-8eb0-00fa52133e81",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_643_063_069_896,
                "updatedByUserId" => 18_622_744,
                "value" => "Alice HOA you know what I'm saying?"
              }
            ]
          },
          "email" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:23938828",
            "timestamp" => 1_631_910_476_412,
            "updatedByUserId" => 23_938_828,
            "value" => " test@org",
            "versions" => [
              %{
                "name" => "email",
                "requestId" => "c4e40e6c-6c37-4b86-b25b-5ebe70f5928d",
                "source" => "CRM_UI",
                "sourceId" => "userId:23938828",
                "sourceVid" => [],
                "timestamp" => 1_631_910_476_412,
                "updatedByUserId" => 23_938_828,
                "value" => " test@org"
              }
            ]
          },
          "phone_number" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_207_202_446,
            "updatedByUserId" => 18_622_744,
            "value" => "555-555-55555",
            "versions" => [
              %{
                "name" => "phone_number",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_207_202_446,
                "updatedByUserId" => 18_622_744,
                "value" => "555-555-55555"
              }
            ]
          },
          "closing_notes" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_631_735_687_264,
            "updatedByUserId" => 18_622_744,
            "value" =>
              "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"",
            "versions" => [
              %{
                "name" => "closing_notes",
                "requestId" => "805f67bd-f77b-46c1-9351-bb6534111577",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_631_735_687_264,
                "updatedByUserId" => 18_622_744,
                "value" =>
                  "\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\""
              }
            ]
          },
          "system_size" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "6000",
            "versions" => [
              %{
                "name" => "system_size",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "6000"
              }
            ]
          },
          "num_associated_contacts" => %{
            "source" => "CALCULATED",
            "sourceId" => "RollupProperties",
            "timestamp" => 1_625_003_882_051,
            "updatedByUserId" => nil,
            "value" => "1",
            "versions" => [
              %{
                "name" => "num_associated_contacts",
                "source" => "CALCULATED",
                "sourceId" => "RollupProperties",
                "sourceVid" => [],
                "timestamp" => 1_625_003_882_051,
                "value" => "1"
              }
            ]
          },
          "proposal_efficiency_equipment" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_635_794_751_733,
            "updatedByUserId" => nil,
            "value" => "LGHT, THERM",
            "versions" => [
              %{
                "name" => "proposal_efficiency_equipment",
                "requestId" => "1668a9de-0929-4d12-a72b-e34b7f7a2494",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_635_794_751_733,
                "value" => "LGHT, THERM"
              }
            ]
          },
          "base_cost" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "22500",
            "versions" => [
              %{
                "name" => "base_cost",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "22500"
              }
            ]
          },
          "lead_source" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_625_005_179_017,
            "updatedByUserId" => 18_622_744,
            "value" => "Self-Gen",
            "versions" => [
              %{
                "name" => "lead_source",
                "requestId" => "49e4c270-67a4-4707-90f6-985cc02d6efe",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_625_005_179_017,
                "updatedByUserId" => 18_622_744,
                "value" => "Self-Gen"
              }
            ]
          },
          "hs_all_owner_ids" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "65678890;70635039;133699987",
            "versions" => [
              %{
                "name" => "hs_all_owner_ids",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "65678890;70635039;133699987"
              }
            ]
          },
          "sighten_contract_interest_rate" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_635_796_076_299,
            "updatedByUserId" => nil,
            "value" => "2.99",
            "versions" => [
              %{
                "name" => "sighten_contract_interest_rate",
                "requestId" => "60db6633-11cc-4770-9dab-1c31fa050766",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_635_796_076_299,
                "value" => "2.99"
              }
            ]
          },
          "pipeline" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_641_579_168_860,
            "updatedByUserId" => 8_514_594,
            "value" => "default",
            "versions" => [
              %{
                "name" => "pipeline",
                "requestId" => "8ccb4d0e-7bd7-4581-a06f-29b68254aa53",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_641_579_168_860,
                "updatedByUserId" => 8_514_594,
                "value" => "default"
              }
            ]
          },
          "hs_num_target_accounts" => %{
            "source" => "CALCULATED",
            "sourceId" => "RollupProperties",
            "timestamp" => 1_625_003_882_051,
            "updatedByUserId" => nil,
            "value" => "0",
            "versions" => [
              %{
                "name" => "hs_num_target_accounts",
                "source" => "CALCULATED",
                "sourceId" => "RollupProperties",
                "sourceVid" => [],
                "timestamp" => 1_625_003_882_051,
                "value" => "0"
              }
            ]
          },
          "dealname" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_625_003_881_362,
            "updatedByUserId" => 18_622_744,
            "value" => "N - New Deal test",
            "versions" => [
              %{
                "name" => "dealname",
                "requestId" => "0d3c4cfe-3c43-4a87-afb3-cab0957819e7",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_362,
                "updatedByUserId" => 18_622_744,
                "value" => "N - New Deal test"
              }
            ]
          },
          "hs_updated_by_user_id" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "8514594",
            "versions" => [
              %{
                "name" => "hs_updated_by_user_id",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "8514594"
              }
            ]
          },
          "estimated_usage_in_first_year" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "12353.931872000001",
            "versions" => [
              %{
                "name" => "estimated_usage_in_first_year",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "12353.931872000001"
              }
            ]
          },
          "utility_account_number" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_286_287_148,
            "updatedByUserId" => 18_622_744,
            "value" => "555-555-555",
            "versions" => [
              %{
                "name" => "utility_account_number",
                "requestId" => "3b6f8a49-50f5-4d50-a23d-511c20362138",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_286_287_148,
                "updatedByUserId" => 18_622_744,
                "value" => "555-555-555"
              }
            ]
          },
          "sighten_contract_term_length" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_635_796_076_299,
            "updatedByUserId" => nil,
            "value" => "7",
            "versions" => [
              %{
                "name" => "sighten_contract_term_length",
                "requestId" => "60db6633-11cc-4770-9dab-1c31fa050766",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_635_796_076_299,
                "value" => "7"
              }
            ]
          },
          "amount_in_home_currency" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "26316.0",
            "versions" => [
              %{
                "name" => "amount_in_home_currency",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "26316.0"
              }
            ]
          },
          "hs_object_id" => %{
            "source" => "CONTACTS",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_625_003_881_362,
            "updatedByUserId" => 18_622_744,
            "value" => "5568776798",
            "versions" => [
              %{
                "name" => "hs_object_id",
                "requestId" => "0d3c4cfe-3c43-4a87-afb3-cab0957819e7",
                "source" => "CONTACTS",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_625_003_881_362,
                "updatedByUserId" => 18_622_744,
                "value" => "5568776798"
              }
            ]
          },
          "site_survey_approved" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_641_324_012_984,
            "updatedByUserId" => nil,
            "value" => "1640649600000",
            "versions" => [
              %{
                "name" => "site_survey_approved",
                "requestId" => "0605c19c-a021-4b38-b316-83941b36f367",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_641_324_012_984,
                "value" => "1640649600000"
              }
            ]
          },
          "date_of_first_sit" => %{
            "source" => "AUTOMATION_PLATFORM",
            "sourceId" => "enrollmentId:186352913816;actionExecutionIndex:1",
            "timestamp" => 1_639_084_585_799,
            "updatedByUserId" => nil,
            "value" => "1639008000000",
            "versions" => [
              %{
                "name" => "date_of_first_sit",
                "source" => "AUTOMATION_PLATFORM",
                "sourceId" => "enrollmentId:186352913816;actionExecutionIndex:1",
                "sourceVid" => [],
                "timestamp" => 1_639_084_585_799,
                "value" => "1639008000000"
              }
            ]
          },
          "state_region" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_643_052_288_434,
            "updatedByUserId" => 18_622_744,
            "value" => "CO",
            "versions" => [
              %{
                "name" => "state_region",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_643_052_288_434,
                "updatedByUserId" => 18_622_744,
                "value" => "CO"
              }
            ]
          },
          "hubspot_team_id" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "3251297",
            "versions" => [
              %{
                "name" => "hubspot_team_id",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "3251297"
              }
            ]
          },
          "first_name" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_207_202_446,
            "updatedByUserId" => 18_622_744,
            "value" => "Nathan",
            "versions" => [
              %{
                "name" => "first_name",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_207_202_446,
                "updatedByUserId" => 18_622_744,
                "value" => "Nathan"
              }
            ]
          },
          "module_count" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_643_911_108_406,
            "updatedByUserId" => nil,
            "value" => "15",
            "versions" => [
              %{
                "name" => "module_count",
                "requestId" => "c695bc4c-ed92-4f76-addf-0c969a28cf08",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_643_911_108_406,
                "value" => "15"
              }
            ]
          },
          "hs_projected_amount" => %{
            "source" => "CALCULATED",
            "sourceId" => "CalculatedPropertyComputer",
            "timestamp" => 1_641_579_169_435,
            "updatedByUserId" => nil,
            "value" => "0.0",
            "versions" => [
              %{
                "name" => "hs_projected_amount",
                "source" => "CALCULATED",
                "sourceId" => "CalculatedPropertyComputer",
                "sourceVid" => [],
                "timestamp" => 1_641_579_169_435,
                "value" => "0.0"
              }
            ]
          },
          "hs_all_accessible_team_ids" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:8514594",
            "timestamp" => 1_645_213_842_329,
            "updatedByUserId" => 8_514_594,
            "value" => "3251297;3315449",
            "versions" => [
              %{
                "name" => "hs_all_accessible_team_ids",
                "source" => "CRM_UI",
                "sourceId" => "userId:8514594",
                "sourceVid" => [],
                "timestamp" => 1_645_213_842_329,
                "updatedByUserId" => 8_514_594,
                "value" => "3251297;3315449"
              }
            ]
          },
          "netsuite_project_id" => %{
            "source" => "API",
            "sourceId" => "Public Object Api",
            "timestamp" => 1_638_477_972_727,
            "updatedByUserId" => nil,
            "value" => "61048",
            "versions" => [
              %{
                "name" => "netsuite_project_id",
                "requestId" => "6717b3af-0dc1-4096-90fd-9c946ea4549a",
                "source" => "API",
                "sourceId" => "Public Object Api",
                "sourceVid" => [],
                "timestamp" => 1_638_477_972_727,
                "value" => "61048"
              }
            ]
          },
          "utility_account_name" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:23938828",
            "timestamp" => 1_631_910_128_281,
            "updatedByUserId" => 23_938_828,
            "value" => "N",
            "versions" => [
              %{
                "name" => "utility_account_name",
                "requestId" => "46ea1598-9c76-46ce-81bb-20ba65e6d8a9",
                "source" => "CRM_UI",
                "sourceId" => "userId:23938828",
                "sourceVid" => [],
                "timestamp" => 1_631_910_128_281,
                "updatedByUserId" => 23_938_828,
                "value" => "N"
              }
            ]
          },
          "last_name" => %{
            "source" => "CRM_UI",
            "sourceId" => "userId:18622744",
            "timestamp" => 1_626_207_202_446,
            "updatedByUserId" => 18_622_744,
            "value" => "Casados",
            "versions" => [
              %{
                "name" => "last_name",
                "source" => "CRM_UI",
                "sourceId" => "userId:18622744",
                "sourceVid" => [],
                "timestamp" => 1_626_207_202_446,
                "updatedByUserId" => 18_622_744,
                "value" => "Casados"
              }
            ]
          },
          "hs_forecast_probability" => %{
            "source" => "AUTOMATION_PLATFORM",
            "sourceId" => "enrollmentId:196805080130;actionExecutionIndex:1",
            "timestamp" => 1_639_084_631_256,
            "updatedByUserId" => nil,
            "value" => "0.0",
            "versions" => [
              %{
                "name" => "hs_forecast_probability",
                "source" => "AUTOMATION_PLATFORM",
                "sourceId" => "enrollmentId:196805080130;actionExecutionIndex:1",
                "sourceVid" => [],
                "timestamp" => 1_639_084_631_256,
                "value" => "0.0"
              }
            ]
          }
        },
        "secondaryIdentifier" => nil,
        "version" => 264
      }
    }
  end
end
