defmodule CopperApi.Schemas.CustomFieldDefinition do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  Wraps the copper datatype in a struct or schema
  """
  alias CopperApi.Schemas.CustomFieldDefinitionOption

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          data_type: String.t(),
          available_on: [String.t()],
          options: nil | [%CustomFieldDefinitionOption{}]
        }
  defstruct [
    :id,
    :name,
    :data_type,
    :available_on,
    :options
  ]

  @spec new(%{
          id: integer(),
          name: String.t(),
          data_type: String.t(),
          available_on: [String.t()],
          options: nil | [%{id: integer(), name: String.t(), rank: integer()}]
        }) :: CopperApi.Schemas.CustomFieldDefinition.t()
  def new(%{
        "id" => id,
        "name" => name,
        "data_type" => data_type,
        "available_on" => available_on
      })
      when data_type != "Dropdown" do
    %__MODULE__{
      id: id,
      name: name,
      data_type: data_type,
      available_on: available_on,
      options: []
    }
  end

  def new(%{
        "id" => id,
        "name" => name,
        "data_type" => data_type,
        "available_on" => available_on,
        "options" => options
      })
      when data_type == "Dropdown" do
    %__MODULE__{
      id: id,
      name: name,
      data_type: data_type,
      available_on: available_on,
      options: Enum.map(options, &CustomFieldDefinitionOption.new/1)
    }
  end
end
