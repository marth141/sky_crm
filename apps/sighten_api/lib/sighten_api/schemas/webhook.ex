defmodule SightenApi.Schemas.Webhook do
  defstruct ~w(
    assigned_to
    comments
    date_updated
    description
    milestone
    milestone_definition
    name
    quote
    site
    status
    sub_tasks
    task_definition
    uuid
  )a

  def new(arg) do
    %__MODULE__{
      assigned_to: arg["assigned_to"],
      comments: arg["comments"],
      date_updated: arg["date_updated"],
      description: arg["description"],
      milestone: arg["milestone"],
      milestone_definition: arg["milestone_definition"],
      name: arg["name"],
      quote: arg["quote"],
      site: arg["site"],
      status: arg["status"],
      sub_tasks: arg["sub_tasks"],
      task_definition: arg["task_definition"],
      uuid: arg["uuid"]
    }
  end
end
