defmodule SkylineOperations.Jobs.CreateNMAPandadocAndUpdateNetsuite do
  use Oban.Worker,
    queue: :skyline_operations

  alias Swoosh.Email

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"project" => _project, "pandadoc_data" => pandadoc_data}})
      when is_nil(pandadoc_data) do
    :ok
  end

  def perform(%Oban.Job{args: %{"project" => project, "pandadoc_data" => pandadoc_data}}) do
    with {:ok, %{body: body, status: 201}} <-
           PandadocApi.create_document_from_template(pandadoc_data) do
      document_id = (body |> Jason.decode!())["uuid"]

      Process.sleep(10000)

      case Application.get_env(:pandadoc_api, :env) do
        :prod ->
          with {:ok, %{labels: ["SENT"]}} <-
                 email_support_at_Org(project, document_id, pandadoc_data),
               :ok <-
                 NetsuiteApi.force_update_job(project["netsuite_project_id"], %{
                   "custentity_skl_auto_created_nma_document" => true
                 }) do
            :ok
          else
            e -> {:error, "#{Kernel.inspect(e)}"}
          end

        :dev ->
          with {:ok, _swoosh_local} <- test_email(project, document_id),
               :ok <-
                 NetsuiteApi.force_update_job(project["netsuite_project_id"], %{
                   "custentity_skl_auto_created_nma_document" => false
                 }) do
            :ok
          else
            e -> {:error, "#{Kernel.inspect(e)}"}
          end

        :test ->
          with {:ok, _swoosh_local} <- test_email(project, document_id),
               :ok <-
                 NetsuiteApi.force_update_job(project["netsuite_project_id"], %{
                   "custentity_skl_auto_created_nma_document" => false
                 }) do
            :ok
          else
            e -> {:error, "#{Kernel.inspect(e)}"}
          end
      end
    else
      {:ok,
       %Finch.Response{
         body:
           "{\"type\":\"validation_error\",\"detail\":{\"template_uuid\":[\"Template is not available.\"]}}",
         status: 400
       }} ->
        {:ok,
         "Template not available for https://org.app.netsuite.com/app/accounting/project/project.nl?id=#{project["netsuite_project_id"]}"}

      e ->
        IO.inspect(e)
        {:error, "#{Kernel.inspect(e)}"}
    end
  end

  def test_email(project, document_id) do
    Email.new()
    |> Email.to("@org")
    |> Email.from({"SkyCRM", "do-not-reply@org.com"})
    |> Email.subject("Test SkyCRM NMA Email")
    |> Email.html_body("""
    #{project["netsuite_project_id"]}
    #{project["custentity_bb_home_owner_name_text"]}
    #{document_id}
    """)
    |> Emailing.deliver()
  end

  def email_support_at_Org(project, document_id, pandadoc_data) do
    Email.new()
    |> Email.to("support@org")
    |> Email.from({"SkyCRM", "do-not-reply@org.com"})
    |> Email.subject("#{pandadoc_data["name"]} via PandaDoc")
    |> Email.html_body("""
    <table width="100%" cellpadding="0" cellspacing="0" border="0" id="m_4479365743915198221background-table">
    <tbody>
    <tr>
    <td align="center" bgcolor="#e5e5e5">
    <table class="m_4479365743915198221w_full" width="480" cellpadding="0" cellspacing="0" border="0">
    <tbody>
    <tr>
    <td class="m_4479365743915198221w_full" width="480" height="30"></td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full" width="480" height="30" align="center">
    <img style="display:block;height:50px;text-align:center;border:none"
    src="https://ci5.googleusercontent.com/proxy/Jp-NwLLSHHizCHQPMxsfZhG3LtvzLUFjU3N69SAzehdrmr8qm03xxyVxf4uzhlw8f71fm0eBLCVHP0c-P1cpsLhWrO4lWpkYoVp-gHroF6DZlpUKCZFoLFjYZIKH-CaHWz6xFL8YeYlC=s0-d-e1-ft#https://pd-ws-static.s3.us-west-2.amazonaws.com:443/602617/logo-1481577618-200x200.png"
    alt="Logo" title="Logo" height="50" border="0" class="m_4479365743915198221logo CToWUd">
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full" width="480" height="30"></td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full" width="480" id="m_4479365743915198221content-table"
    bgcolor="#ffffff" align="center">
    <table class="m_4479365743915198221w_full" width="480" cellpadding="0" cellspacing="0" border="0">
    <tbody>
    <tr>
    <td class="m_4479365743915198221w_full" width="480" height="30"></td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full" width="480">
    <table class="m_4479365743915198221w_full" width="480" cellpadding="0" cellspacing="0"
    border="0">
    <tbody>
    <tr>
    <td class="m_4479365743915198221w_padding" width="40"></td>
    <td class="m_4479365743915198221w_full_with_padding" width="400">
    <table class="m_4479365743915198221w_full_with_padding" width="400" cellpadding="0"
    cellspacing="0" border="0">
    <tbody>
    <tr>
    <td class="m_4479365743915198221w_full_with_padding" width="400">
    <table class="m_4479365743915198221w_full_with_padding" width="400"
    cellpadding="0" cellspacing="0" border="0">
    <tbody>
    <tr>
    <td width="70" valign="top">
    <img
    src="https://ci5.googleusercontent.com/proxy/K49O4oRhRwlV_XJF9p9vv2zZky8KVWTDWOx-c_NM_HrVk0blho0u8gWC2o9zvnpI7gtdLRfB7VaWMd2oEK7RzTOQTwf3GfSFYNNJ-Iot2Kza9Hx1jfM=s0-d-e1-ft#https://api.pandadoc.com/avatar?q=salessupport%40org&amp;s=40"
    alt="" width="50" height="50" style="margin:5px 0 0 0" class="CToWUd">
    </td>
    <td class="m_4479365743915198221w_message" width="330" valign="top"
    style="font-family:'Helvetica Neue','Helvetica',Arial,sans-serif;font-size:15px;color:#333b40;margin:0;padding:0;border-collapse:collapse;line-height:22px!important">
    <b>Org</b> sent you "<b>[DEV] #{project["netsuite_project_id"]} #{project["custentity_bb_home_owner_name_text"]} NMA Document</b>".
    </td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full_with_padding" width="400">
    <hr size="1" noshade=""
    style="margin:10px 0 20px 0;border:none;color:#eaeaea;background-color:#eaeaea;height:1px"
    class="m_4479365743915198221separator">
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full_with_padding" width="400">
    <p
    style="font-family:'Helvetica Neue','Helvetica',Arial,sans-serif;font-size:15px;color:#333b40;margin:0;padding:0;border-collapse:collapse;line-height:22px!important">
    SkyCRM has produced a NMA Document and it can be viewed by clicking 'Open the
    Document'</p>
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full_with_padding" width="400">
    <hr size="1" noshade=""
    style="margin:10px 0 20px 0;border:none;color:#eaeaea;background-color:#eaeaea;height:1px"
    class="m_4479365743915198221separator">
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full_with_padding" width="400" align="center">
    <table border="0" cellpadding="0" cellspacing="0"
    style="width:100%;text-align:center;border-collapse:separate;border-top-left-radius:3px;border-top-right-radius:3px;border-bottom-right-radius:3px;border-bottom-left-radius:3px">
    <tbody>
    <tr>
    <td valign="middle"
    style="border-radius:2px;font-size:16px;letter-spacing:1.2px;padding:11px 25px;margin-right:20px;background-color:#47b972">
    <a title="Open the document"
    href="https://app.pandadoc.com/a/#/documents/#{document_id}"
    style="font-size:13px;line-height:100%;text-align:center;text-decoration:none;color:#ffffff;word-wrap:break-word;text-transform:uppercase"
    target="_blank"
    rel="noopener noreferrer">
    Open the document
    </a>
    </td>
    <td width="16"></td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    </tbody>
    </table>
    </td>
    <td class="m_4479365743915198221w_padding" width="40"></td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full m_4479365743915198221media_padding" width="480"
    style="padding-top:10px;padding-bottom:20px">
    </td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full" width="480" height="15">
    </td>
    </tr>
    <tr>
    <td class="m_4479365743915198221w_full" width="480">
    </td>
    </tr>
    </tbody>
    </table>
    </td>
    </tr>
    </tbody>
    </table>
    """)
    |> Emailing.deliver()
  end
end
