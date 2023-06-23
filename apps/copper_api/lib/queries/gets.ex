defmodule CopperApi.Queries.Get do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  This module is for getting copper stuff from the local copper postgres.
  """
  alias CopperApi.Schemas.{
    CustomField,
    CustomFieldDefinitionOption,
    CustomFieldDefinition
  }

  alias CopperApi.Queries.Get
  alias CopperApi.ActivityType, as: Activities
  alias CopperApi.Pipelines
  alias CopperApi.CustomFields
  alias CopperApi.Users
  alias CopperApi.Schemas.User

  def activity_type_id_by_name(activity_type_name) when is_binary(activity_type_name) do
    Activities.list_activity_types()
    |> Enum.filter(fn %CopperApi.Schemas.ActivityType{name: name} ->
      name == activity_type_name
    end)
    |> List.first()
    |> Map.get(:id)
  end

  def activity_type_name_by_id(activity_type_id) when is_integer(activity_type_id) do
    Activities.list_activity_types()
    |> Enum.filter(fn %CopperApi.Schemas.ActivityType{id: id} ->
      id == activity_type_id
    end)
    |> List.first()
    |> Map.get(:name)
  end

  def pipeline_id_by_name(pipeline_name) do
    Pipelines.list_pipelines()
    |> Enum.filter(fn %CopperApi.Schemas.Pipeline{name: name} -> name == pipeline_name end)
    |> List.first()
    |> Map.get(:id)
  end

  def pipeline_name_by_id(pipeline_id) do
    Pipelines.list_pipelines()
    |> Enum.filter(fn %CopperApi.Schemas.Pipeline{id: id} -> id == pipeline_id end)
    |> List.first()
    |> Map.get(:name)
  end

  def pipeline_stage_id_by_name(input_pipeline_name, input_pipeline_stage_name) do
    Pipelines.list_pipelines()
    |> Enum.filter(fn %CopperApi.Schemas.Pipeline{name: pipeline_name} ->
      pipeline_name == input_pipeline_name
    end)
    |> Enum.map(fn %CopperApi.Schemas.Pipeline{stages: stages} ->
      Enum.find_value(stages, fn %CopperApi.Schemas.Stages{id: stage_id, name: stage_name} ->
        if(input_pipeline_stage_name == stage_name, do: stage_id)
      end)
    end)
    |> List.first()
  end

  def pipeline_stage_name_by_id(input_pipeline_id, input_pipeline_stage_id) do
    Pipelines.list_pipelines()
    |> Enum.filter(fn %CopperApi.Schemas.Pipeline{id: pipeline_id} ->
      pipeline_id == input_pipeline_id
    end)
    |> Enum.map(fn %CopperApi.Schemas.Pipeline{stages: stages} ->
      Enum.find_value(stages, fn %CopperApi.Schemas.Stages{id: stage_id, name: stage_name} ->
        if(input_pipeline_stage_id == stage_id, do: stage_name)
      end)
    end)
    |> List.first()
  end

  def custom_field_definition_by_name(custom_field_name) when is_binary(custom_field_name) do
    CustomFields.list_custom_fields()
    |> Enum.filter(fn %CopperApi.Schemas.CustomFieldDefinition{name: name} ->
      name == custom_field_name
    end)
    |> List.first()
  end

  def custom_field_definition_id_by_name(custom_field_name) when is_binary(custom_field_name) do
    CustomFields.list_custom_fields()
    |> Enum.filter(fn %CopperApi.Schemas.CustomFieldDefinition{name: name} ->
      name == custom_field_name
    end)
    |> List.first()
    |> Map.get(:id)
  end

  def custom_field_definition_id_by_name(custom_field_name) when is_integer(custom_field_name) do
    CustomFields.list_custom_fields()
    |> Enum.filter(fn %CopperApi.Schemas.CustomFieldDefinition{id: id} ->
      id == custom_field_name
    end)
    |> List.first()
    |> Map.get(:id)
  end

  def custom_field_definition_by_id(custom_field_id) when is_integer(custom_field_id) do
    CustomFields.list_custom_fields()
    |> Enum.filter(fn %CopperApi.Schemas.CustomFieldDefinition{id: id} ->
      id == custom_field_id
    end)
    |> List.first()
  end

  def custom_field_definition_name_by_id(custom_field_name) when is_binary(custom_field_name) do
    CustomFields.list_custom_fields()
    |> Enum.filter(fn %CopperApi.Schemas.CustomFieldDefinition{name: name} ->
      name == custom_field_name
    end)
    |> List.first()
    |> Map.get(:id)
  end

  def copper_user_name_from_copper_id(copper_user_id) do
    Users.list_users()
    |> Enum.map(fn %User{id: id, name: name} -> if id == copper_user_id, do: name end)
    |> Enum.filter(fn x -> x != nil end)
    |> List.first()
  end

  def copper_email_from_copper_id(copper_user_id) do
    Users.list_users()
    |> Enum.map(fn %User{id: id, email: email} -> if id == copper_user_id, do: email end)
    |> Enum.filter(fn x -> x != nil end)
    |> List.first()
  end

  def copper_user_id_from_copper_name(copper_user_name) do
    Users.list_users()
    |> Enum.map(fn %User{id: id, name: name} -> if name == copper_user_name, do: id end)
    |> Enum.filter(fn x -> x != nil end)
    |> List.first()
  end

  def from_custom_fields_setter_specialist(custom_fields) do
    with %CustomFieldDefinition{id: definition_id, options: definition_options} <-
           Get.custom_field_definition_by_name("Setter/Specialist Name") do
      Enum.map(custom_fields, &CustomField.new/1)
      |> Enum.map(fn %CustomField{
                       custom_field_definition_id: custom_field_id,
                       value: value
                     } ->
        case custom_field_id do
          ^definition_id ->
            Enum.find_value(definition_options, fn %CustomFieldDefinitionOption{
                                                     id: option_id,
                                                     name: option_name
                                                   } ->
              case option_id do
                ^value -> option_name
                _ -> nil
              end
            end)

          _ ->
            nil
        end
      end)
      |> Enum.filter(fn element -> element != nil end)
      |> List.first()
    else
      err -> err
    end
  end

  def from_custom_fields_value_where_name(custom_fields, name) do
    with %CustomFieldDefinition{id: definition_id} <-
           Get.custom_field_definition_by_name(name) do
      Enum.map(custom_fields, &CustomField.new/1)
      |> Enum.map(fn %CustomField{
                       custom_field_definition_id: custom_field_id,
                       value: value
                     } ->
        case custom_field_id do
          ^definition_id ->
            value

          _ ->
            nil
        end
      end)
      |> Enum.filter(fn element -> element != nil end)
      |> List.first()
    else
      err -> err
    end
  end

  def from_custom_fields_dropdowns_value_where_name(custom_fields, dropdown_name) do
    with %CustomFieldDefinition{id: definition_id, options: definition_options} <-
           Get.custom_field_definition_by_name(dropdown_name) do
      Enum.map(custom_fields, &CustomField.new/1)
      |> Enum.map(fn %CustomField{
                       custom_field_definition_id: custom_field_id,
                       value: value
                     } ->
        case custom_field_id do
          ^definition_id ->
            Enum.find_value(definition_options, fn %CustomFieldDefinitionOption{
                                                     id: option_id,
                                                     name: option_name
                                                   } ->
              case option_id do
                ^value -> option_name
                _ -> nil
              end
            end)

          _ ->
            nil
        end
      end)
      |> Enum.filter(fn element -> element != nil end)
      |> List.first()
    else
      err -> err
    end
  end

  def custom_field_dropdown_value_id_by_name(dropdown_name, dropdown_value)
      when is_integer(dropdown_name) do
    with %CustomFieldDefinition{options: definition_options} <-
           Get.custom_field_definition_by_id(dropdown_name) do
      Enum.find_value(definition_options, fn %CustomFieldDefinitionOption{
                                               id: option_id,
                                               name: option_name
                                             } ->
        case option_name do
          ^dropdown_value -> option_id
          _ -> nil
        end
      end)
    else
      err -> err
    end
  end

  def custom_field_dropdown_value_id_by_name(dropdown_name, dropdown_value)
      when is_binary(dropdown_name) do
    with %CustomFieldDefinition{options: definition_options} <-
           Get.custom_field_definition_by_name(dropdown_name) do
      Enum.find_value(definition_options, fn %CustomFieldDefinitionOption{
                                               id: option_id,
                                               name: option_name
                                             } ->
        case option_name do
          ^dropdown_value -> option_id
          _ -> nil
        end
      end)
    else
      err -> err
    end
  end

  def custom_field_dropdown_value_name_by_id(dropdown_value_id, dropdown_id) do
    with %CustomFieldDefinition{options: definition_options} <-
           Get.custom_field_definition_by_id(dropdown_id) do
      Enum.find_value(definition_options, fn %CustomFieldDefinitionOption{
                                               id: option_id,
                                               name: option_name
                                             } ->
        case option_id do
          ^dropdown_value_id -> option_name
          _ -> nil
        end
      end)
    else
      err -> err
    end
  end

  def fetch_install_areas() do
    definition = custom_field_definition_by_name("Install Area")

    definition
    |> Map.get(:options)
    |> Enum.map(
      &{&1.name
       |> String.downcase()
       |> String.replace("-", "")
       |> String.replace(" ", "_")
       |> String.replace("__", "_")
       |> String.to_atom(),
       %{
         name: &1.name,
         parent_id: definition |> Map.get(:id),
         option_id: &1.id
       }}
    )
    |> Map.new()
  end

  def get_install_area(%CopperApi.Schemas.Opportunity{
        custom_fields: custom_fields
      }) do
    install_areas = fetch_install_areas()

    %CustomFieldDefinition{id: definition_id} = custom_field_definition_by_name("Install Area")

    Enum.map(custom_fields, &CustomField.new/1)
    |> Enum.find_value(fn
      %CustomField{
        custom_field_definition_id: custom_field_definition_id,
        value: value
      }
      when definition_id == custom_field_definition_id ->
        Enum.find_value(install_areas, fn
          {_, %{name: name, option_id: option_id}}
          when option_id == value ->
            name

          _ ->
            false
        end)

      _ ->
        false
    end)
  end

  def get_install_area(%CopperApi.Schemas.Lead{
        custom_fields: custom_fields
      }) do
    install_areas = fetch_install_areas()

    %CustomFieldDefinition{id: definition_id} = custom_field_definition_by_name("Install Area")

    Enum.map(custom_fields, &CustomField.new/1)
    |> Enum.find_value(fn
      %CustomField{
        custom_field_definition_id: custom_field_definition_id,
        value: value
      }
      when definition_id == custom_field_definition_id ->
        Enum.find_value(install_areas, fn
          {_, %{name: name, option_id: option_id}}
          when option_id == value ->
            name

          _ ->
            false
        end)

      _ ->
        false
    end)
  end

  def get_install_area(%CopperApi.Schemas.RelatedResource{id: id, type: type})
      when type == "opportunity" do
    try do
      Repo.get_by(Opportunity, copper_id: id)
      |> get_install_area()
    rescue
      err -> err
    end
  end

  def get_install_area(%CopperApi.Schemas.RelatedResource{id: id, type: type})
      when type == "lead" do
    try do
      CopperApi.Leads.fetch(id)
      |> get_install_area()
    rescue
      err -> err
    end
  end

  def get_install_area(%CopperApi.Schemas.RelatedResource{type: type}),
    do: type

  def get_install_area(custom_fields) do
    install_areas = fetch_install_areas()

    %CustomFieldDefinition{id: definition_id} = custom_field_definition_by_name("Install Area")

    Enum.map(custom_fields, &CustomField.new/1)
    |> Enum.find_value(fn
      %CustomField{
        custom_field_definition_id: custom_field_definition_id,
        value: value
      }
      when definition_id == custom_field_definition_id ->
        Enum.find_value(install_areas, fn
          {_, %{name: name, option_id: option_id}}
          when option_id == value ->
            name

          _ ->
            false
        end)

      _ ->
        false
    end)
  end
end
