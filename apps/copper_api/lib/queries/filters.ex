defmodule CopperApi.Queries.Filter do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module is for doing filtery queries on the local copper postgres.
  """
  alias CopperApi.Schemas.Opportunity
  alias CopperApi.Schemas.Task
  alias CopperApi.Schemas.CustomField
  alias CopperApi.Schemas.CustomFieldDefinition
  alias CopperApi.Schemas.CustomFieldDefinitionOption
  alias CopperApi.Queries.Get

  def by_pipeline_id(copper_list, pipeline_id_to_filter) do
    copper_list
    |> Enum.filter(fn %Opportunity{pipeline_id: pipeline_id} ->
      pipeline_id == pipeline_id_to_filter
    end)
  end

  def by_activity_type_id(copper_list, activity_type_id) do
    Enum.filter(copper_list, fn %Task{custom_activity_type_id: custom_activity_type_id} ->
      custom_activity_type_id == activity_type_id
    end)
  end

  def by_custom_field_and_option(copper_list, custom_field_name_to_find, option_name_to_find) do
    Enum.filter(copper_list, fn %{custom_fields: custom_fields} ->
      Enum.map(custom_fields, &CustomField.new/1)
      |> Enum.find_value(fn %CustomField{
                              custom_field_definition_id: custom_field_definition_id,
                              value: custom_field_value_id
                            } ->
        %CustomFieldDefinition{
          name: custom_field_name_to_match,
          options: options_to_search
        } = Get.custom_field_definition_by_id(custom_field_definition_id)

        cond do
          custom_field_name_to_match == custom_field_name_to_find ->
            options_to_search
            |> Enum.find_value(fn %CustomFieldDefinitionOption{
                                    name: option_name_to_match,
                                    id: option_id_to_match
                                  } ->
              cond do
                option_name_to_match == option_name_to_find ->
                  option_id_to_match == custom_field_value_id

                true ->
                  false
              end
            end)

          true ->
            false
        end
      end)
    end)
  end

  def by_closed_date([%Opportunity{} | _tail] = copper_list, start_date, end_date) do
    Enum.filter(copper_list, fn %Opportunity{close_date: close_date} ->
      cond do
        is_nil(close_date) ->
          false

        true ->
          close_date = close_date |> TimeApi.from_unix()

          (:eq == Date.compare(close_date, start_date) or
             :gt == Date.compare(close_date, start_date)) and
            (:eq == Date.compare(close_date, end_date) or
               :lt == Date.compare(close_date, end_date))
      end
    end)
  end

  def by_date_created(copper_list, start_date, end_date) do
    Enum.filter(copper_list, fn %{due_date: due_date} ->
      cond do
        is_nil(due_date) ->
          false

        true ->
          due_date = due_date

          (:eq == DateTime.compare(due_date, start_date) or
             :gt == DateTime.compare(due_date, start_date)) and
            (:eq == DateTime.compare(due_date, end_date) or
               :lt == DateTime.compare(due_date, end_date))
      end
    end)
  end

  def by_disposition(fulfillment_list, disposition_to_filter) do
    Enum.filter(fulfillment_list, fn %{disposition: disposition} ->
      disposition == disposition_to_filter
    end)
  end

  def by_market(fulfillment_list, market_to_filter) do
    Enum.filter(fulfillment_list, fn %{market: market} ->
      market == market_to_filter
    end)
  end

  def by_status(fulfillment_list, status_to_filter) do
    Enum.filter(fulfillment_list, fn %{status: status} -> status == status_to_filter end)
  end

  def by_disposition_missing(fulfillment_list, true) do
    Enum.filter(fulfillment_list, fn %{disposition: disposition} -> disposition == nil end)
  end

  def by_disposition_missing(fulfillment_list, false), do: fulfillment_list

  def by_incomplete(fulfillment_list, true) do
    Enum.filter(fulfillment_list, fn %{disposition: disposition} ->
      disposition != "Crew - Completed" and disposition != "Pass" and
        disposition != "Pass- with conditions"
    end)
  end

  def by_incomplete(fulfillment_list, false), do: fulfillment_list

  def by_due_date_missing(copper_list, true) do
    Enum.filter(copper_list, fn %{due_date: due_date} ->
      is_nil(due_date)
    end)
  end

  def by_due_date_missing(copper_list, false), do: copper_list
end
