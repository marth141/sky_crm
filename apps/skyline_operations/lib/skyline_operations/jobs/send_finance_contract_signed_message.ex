defmodule SkylineOperations.SendFinanceContractSignedMessage do
  use Oban.Worker,
    queue: :skyline_operations

  alias Swoosh.Email

  @impl Oban.Worker
  def perform(%Oban.Job{args: webhook}) do
    # Send Jessica and Email when a contract is signed
    with %SightenApi.Schemas.Webhook{site: site} <- SightenApi.Schemas.Webhook.new(webhook),
         %SightenApi.Schemas.Site{contacts: contacts} <-
           SightenApi.fetch_site_by_id(site)
           |> (fn {:ok, %{body: body}} -> SightenApi.Schemas.Site.new(body) end).(),
         %SightenApi.Schemas.Site.Contact{first_name: f_name, last_name: l_name} <-
           List.first(contacts),
         {:ok, _} <-
           Email.new()
           |> Email.to("jessica.hinds@org")
           |> Email.from({"SkyCRM", "do-not-reply@org.com"})
           |> Email.subject("#{f_name} #{l_name} has signed their contract!")
           |> Email.html_body("""
           Hey there Jessica,


           This is an automated message to let you know that the customer #{f_name} #{l_name} has just signed their docusign contract--in real time.


           Thanks!
           SkyCRM
           """)
           |> Emailing.deliver() do
      :ok
    else
      anything -> {:error, anything}
    end
  end
end
