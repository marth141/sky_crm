defmodule SkylineOperations.PandaDocTemplates do
  import Ecto.Query

  def determine_pandadocs_template(%NetsuiteApi.Project{} = project) do
    [determine_utility_docs(project) | [determine_ahj_docs(project)]]
    |> List.flatten()
    |> Enum.filter(fn
      nil -> false
      _ -> true
    end)
  end

  def determine_utility_docs(%NetsuiteApi.Project{} = project)
      when is_nil(project.custentity_bb_utility_company) do
    nil
  end

  def determine_utility_docs(%NetsuiteApi.Project{} = project)
      when not is_nil(project.custentity_bb_utility_company) do
    alias SkylineOperations.SkylinePandadocDefiniton

    [utility_company | _uct] =
      Repo.all(
        from(u in NetsuiteApi.UtilityCompany,
          where: u.netsuite_utility_company_id == ^project.custentity_bb_utility_company
        )
      )

    cond do
      utility_company.name in ["MidAmerican Energy (IA)"] ->
        [%SkylinePandadocDefiniton{id: "p52rLAroEru6iFToFMRHAj", type: "NMA"}]

      utility_company.name in ["Delta-Montrose Electric"] ->
        [%SkylinePandadocDefiniton{id: "KQ7JwTtsvxLEPN4vc9tFgX", type: "NMA"}]

      utility_company.name in ["Grand Valley Power"] ->
        [%SkylinePandadocDefiniton{id: "8N2vRLiucEpWcgKSRX5HVL", type: "NMA"}]

      utility_company.name in ["High West"] ->
        [%SkylinePandadocDefiniton{id: "fmqw6sJyjEjod9sFMKZ7a5", type: "NMA"}]

      utility_company.name in ["Intermountain-Rural Electric"] ->
        [%SkylinePandadocDefiniton{id: "NqZmGefjmF2VmwR5WYShxS", type: "NMA"}]

      utility_company.name in ["Linn County"] ->
        [%SkylinePandadocDefiniton{id: "RMWLJ9yy427eJKTapc5pJE", type: "NMA"}]

      utility_company.name in ["Loveland Utility"] ->
        [%SkylinePandadocDefiniton{id: "NRTrQYZksYcThK6VgtWaH5", type: "NMA"}]

      utility_company.name in ["MVEA"] ->
        [%SkylinePandadocDefiniton{id: "tLiMwfTqezPkPEDeoYt26A", type: "NMA"}]

      utility_company.name in ["United Power"] ->
        [%SkylinePandadocDefiniton{id: "444J4AzSjn83EeJwSHiXm9", type: "NMA"}]

      true ->
        nil
    end
  end

  def determine_ahj_docs(%NetsuiteApi.Project{} = project)
      when is_nil(project.custentity_bb_auth_having_jurisdiction) do
    nil
  end

  def determine_ahj_docs(%NetsuiteApi.Project{} = project)
      when not is_nil(project.custentity_bb_auth_having_jurisdiction) do
    alias SkylineOperations.SkylinePandadocDefiniton

    [ahj | _ahjt] =
      Repo.all(
        from(u in NetsuiteApi.AuthorityHandlingJurisdiction,
          where:
            u.netsuite_authority_handling_jurisdiction_id ==
              ^project.custentity_bb_auth_having_jurisdiction
        )
      )

    cond do
      ahj.name in [
        "Mesa County",
        "Fruita/Mesa County",
        "Orchard Mesa",
        "Palisade/Mesa County",
        "Grand Junction"
      ] ->
        [%SkylinePandadocDefiniton{id: "SFABX8GLAAq2McMBiR2VGo", type: "Building Permit"}]

      ahj.name in ["Waterloo"] ->
        [
          %SkylinePandadocDefiniton{id: "jFGrnJHKLc4cqgN62HrWRU", type: "Building Permit"},
          %SkylinePandadocDefiniton{id: "q4NtJ7LiFuFfP4Wi9BWNHN", type: "Electrical Permit"}
        ]

      ahj.name in ["Dubuque"] ->
        [
          %SkylinePandadocDefiniton{id: "mN7EMerkPPVFhrgPJNvBtc", type: "Electrical Permit"}
        ]

      ahj.name in ["Cedar Rapids"] ->
        [
          %SkylinePandadocDefiniton{id: "jgUJatba78RaMPoZM57XJh", type: "Electrical Permit"}
        ]

      ahj.name in ["Davenport"] ->
        [
          %SkylinePandadocDefiniton{id: "YPJu5ptR4chL9FsMnwevnc", type: "Building Permit"},
          %SkylinePandadocDefiniton{id: "JExDFWBmZzvfBaZXWkJMcP", type: "Electrical Permit"}
        ]

      ahj.name in ["West Des Moines"] ->
        [
          %SkylinePandadocDefiniton{id: "AiFjfQaQa3d7nvgeBeAMQa", type: "Electrical Permit"}
        ]

      true ->
        nil
    end
  end

  def shotgun_fill_pandadoc_template(
        pandadoc_template_id,
        pandadoc_document_type,
        %NetsuiteApi.Project{
          custentity_sk_utility_account_name: utility_account_name,
          custentity_bb_install_address_1_text: street_address,
          custentity_bb_install_city_text: city,
          custentity_bb_install_state: state,
          custentity_bb_install_zip_code_text: zip,
          custentity_bb_home_owner_phone: customer_phone,
          custentity_bb_home_owner_primary_email: customer_email,
          custentity_sk_utility_account_number: utility_account_number,
          custentity_actgrp_133_end_date: onboarding_end_date,
          custentity_bb_inverter_quantity_num: inverter_size,
          custentity_sk_inverter_model: inverter_model,
          custentity_sk_module_model: panel_model,
          custentity_bb_module_quantity_num: number_of_panels,
          custentity_bb_home_owner_name_text: customer_name,
          netsuite_project_id: netsuite_project_id,
          custentity_bb_fin_prelim_purch_price_amt: purchase_price,
          custentity_bb_system_size_decimal: system_size,
          custentity_sk_array_type: array_type,
          custentity_bb_first_name: custentity_bb_first_name,
          custentity_bb_last_name: custentity_bb_last_name
        }
      ) do
    _fill_data =
      %{
        "name" => "#{netsuite_project_id} #{customer_name} #{pandadoc_document_type} Document",
        "template_uuid" => pandadoc_template_id,
        "folder_uuid" => get_env_pandadoc_folder_id(),
        "recipients" => [
          %{
            "email" => "support@org",
            "first_name" => "Skyline",
            "last_name" => "Support"
          }
        ],
        "fields" => %{
          "netsuite.utility_account_name" => %{
            "value" => utility_account_name
          },
          "netsuite.utility_account_number" => %{
            "value" => utility_account_number
          },
          "netsuite.street_address" => %{
            "value" => street_address
          },
          "netsuite.city" => %{
            "value" => city
          },
          "netsuite.state" => %{
            "value" =>
              state
              |> (fn state ->
                    %{custrecord_bb_state_full_name_text: state_name} =
                      Repo.get_by!(NetsuiteApi.State, netsuite_state_id: state)

                    state_name
                  end).()
          },
          "netsuite.zip" => %{
            "value" => zip
          },
          "netsuite.customer_phone" => %{
            "value" => customer_phone
          },
          "netsuite.customer_email" => %{
            "value" => customer_email
          },
          "netsuite.purchase_price" => %{
            "value" => purchase_price
          },
          "netsuite.system_size_kilowatts" => %{
            "value" =>
              system_size
              |> (fn string ->
                    {decimal, _} = Decimal.parse(string)

                    Decimal.div(decimal, 1000)
                    |> Decimal.to_string()
                  end).()
          },
          "netsuite.system_size_watts" => %{
            "value" => system_size
          },
          "netsuite.mesa_description_of_work_planned" => %{
            "value" => """
            #{array_type} PV: (# kW-DC | # kW-AC)
            MODULE: (#{number_of_panels}) #{panel_model}
            INVERTER: (1) #{inverter_model}
            """
          },
          "netsuite.array_type" => %{
            "value" => array_type
          },
          "netsuite.number_of_panels" => %{
            "value" => number_of_panels
          },
          "netsuite.panel_model" => %{
            "value" => panel_model
          },
          "netsuite.inverter_model" => %{
            "value" => inverter_model
          },
          "netsuite.inverter_size" => %{
            "value" => inverter_size
          },
          "netsuite.onboarding_end_date" => %{
            "value" => onboarding_end_date
          },
          "netsuite.homeowner_name" => %{
            "value" => customer_name
          },
          "netsuite.waterloo_one_third" => %{
            "value" =>
              purchase_price
              |> (fn string ->
                    {decimal, _} = Decimal.parse(string)

                    Decimal.mult(decimal, Decimal.from_float(0.33))
                    |> Decimal.round(2)
                    |> Decimal.to_string()
                  end).()
          },
          "netsuite.waterloo_two_third" => %{
            "value" =>
              purchase_price
              |> (fn string ->
                    {decimal, _} = Decimal.parse(string)

                    Decimal.mult(decimal, Decimal.from_float(0.66))
                    |> Decimal.round(2)
                    |> Decimal.to_string()
                  end).()
          },
          "netsuite.first_name" => %{
            "value" => custentity_bb_first_name
          },
          "netsuite.last_name" => %{
            "value" => custentity_bb_last_name
          }
        }
      }
      |> remove_nils()
  end

  defp remove_nils(map) do
    map
    |> Map.update("fields", nil, fn map ->
      Enum.map(map, fn {k, %{"value" => v}} ->
        {k, if(is_nil(v), do: %{"value" => ""}, else: %{"value" => v})}
      end)
      |> Map.new()
    end)
  end

  def get_env_pandadoc_folder_id() do
    case Application.get_env(:pandadoc_api, :env) do
      :prod ->
        "kU9mDPbxAd2WNt28nLKge2"

      :dev ->
        "58bLcsRwZxzsxYYfeyrxfX"

      :test ->
        "58bLcsRwZxzsxYYfeyrxfX"
    end
  end
end
