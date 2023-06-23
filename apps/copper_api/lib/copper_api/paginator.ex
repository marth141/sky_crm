defmodule CopperApi.Paginator do
  @moduledoc """
  Author(s): Nathan Casados (marth141 @ github)

  The magnum opus of this API Wrapper.

  This thing tears through an endpoints pagination of records by using a "Stream.resource"

  First in the resource, it'll "fetch_a_page" which will take some initial query params and get the first page.

  That result will go into "process_page" where it'll determine whether or not to continue collecting pages.

  Once all the pages are collected, "fn pagination -> pagination" will spit out our list of collected thing from the Copper endpoint.

  When used concurrently like it is with "Task.async_stream" someone can collect many pages of records very quickly and get blocked from Copper.
  """
  alias CopperApi.Client, as: Client

  def stream(%{
        url: url,
        results_per_page: page_size,
        first_page: page_number,
        minimum_created_date: minimum_created_date,
        maximum_created_date: maximum_created_date,
        pipeline_ids: pipeline_ids,
        status_ids: status_ids
      }) do
    Task.async_stream(
      Stream.resource(
        # initial case, for the first page
        fn ->
          fetch_a_page(%{
            url: url,
            page_number: page_number,
            minimum_created_date: minimum_created_date,
            maximum_created_date: maximum_created_date,
            page_size: page_size,
            pipeline_ids: pipeline_ids,
            status_ids: status_ids
          })
        end,
        # for the next page
        &process_page/1,
        # for all content fetched we done
        fn pagination -> pagination end
      ),
      fn response -> response end
    )
  end

  def stream(%{
        url: url,
        results_per_page: page_size,
        first_page: page_number,
        minimum_activity_date: minimum_created_date,
        maximum_activity_date: maximum_created_date,
        activity_types: [%{id: copper_id, category: copper_type}]
      }) do
    Task.async_stream(
      Stream.resource(
        # initial case, for the first page
        fn ->
          fetch_a_page(%{
            url: url,
            page_number: page_number,
            minimum_activity_date: minimum_created_date,
            maximum_activity_date: maximum_created_date,
            page_size: page_size,
            activity_types: [%{id: copper_id, category: copper_type}]
          })
        end,
        # for the next page
        &process_page/1,
        # for all content fetched we done
        fn pagination -> pagination end
      ),
      fn response -> response end
    )
  end

  defp process_page({nil, nil}) do
    {:halt, nil}
  end

  defp process_page(
         {nil,
          %{
            url: url,
            page_number: page_number,
            page_size: page_size,
            minimum_created_date: minimum_created_date,
            maximum_created_date: maximum_created_date,
            pipeline_ids: pipeline_ids,
            status_ids: status_ids
          }}
       ) do
    fetch_a_page(%{
      url: url,
      page_number: page_number,
      minimum_created_date: minimum_created_date,
      maximum_created_date: maximum_created_date,
      page_size: page_size,
      pipeline_ids: pipeline_ids,
      status_ids: status_ids
    })
    |> process_page()
  end

  defp process_page(
         {nil,
          %{
            url: url,
            page_number: page_number,
            page_size: page_size,
            minimum_activity_date: minimum_created_date,
            maximum_activity_date: maximum_created_date,
            activity_types: [%{id: copper_id, category: copper_type}]
          }}
       ) do
    fetch_a_page(%{
      url: url,
      page_number: page_number,
      minimum_activity_date: minimum_created_date,
      maximum_activity_date: maximum_created_date,
      page_size: page_size,
      activity_types: [%{id: copper_id, category: copper_type}]
    })
    |> process_page()
  end

  defp process_page({items, next_page_params}) do
    {items, {nil, next_page_params}}
  end

  def fetch_a_page(%{
        url: url,
        page_number: page_number,
        minimum_created_date: minimum_created_date,
        maximum_created_date: maximum_created_date,
        page_size: page_size,
        pipeline_ids: pipeline_ids,
        status_ids: status_ids
      }) do
    page_params =
      %{
        page_number: page_number,
        page_size: page_size,
        minimum_created_date: minimum_created_date,
        maximum_created_date: maximum_created_date
      }
      |> maybe_pipeline_ids(pipeline_ids)
      |> maybe_status_ids(status_ids)

    case Client.post(url, page_params) do
      {:ok, %{status: 200} = response} ->
        handle_success(response, %{
          url: url,
          page_number: page_number,
          minimum_created_date: minimum_created_date,
          maximum_created_date: maximum_created_date,
          page_size: page_size,
          pipeline_ids: pipeline_ids,
          status_ids: status_ids
        })

      {:error, :timeout} ->
        fetch_a_page(%{
          url: url,
          page_number: page_number,
          minimum_created_date: minimum_created_date,
          maximum_created_date: maximum_created_date,
          page_size: page_size,
          pipeline_ids: pipeline_ids,
          status_ids: status_ids
        })
    end
  end

  def fetch_a_page(%{
        url: url,
        page_number: page_number,
        minimum_activity_date: minimum_created_date,
        maximum_activity_date: maximum_created_date,
        page_size: page_size,
        activity_types: [%{id: copper_id, category: copper_type}]
      }) do
    page_params = %{
      page_number: page_number,
      page_size: page_size,
      minimum_activity_date: minimum_created_date,
      maximum_activity_date: maximum_created_date,
      activity_types: [%{id: copper_id, category: copper_type}]
    }

    case Client.post(url, page_params) do
      {:ok, %{status: 200} = response} ->
        handle_success(response, %{
          url: url,
          page_number: page_number,
          minimum_activity_date: minimum_created_date,
          maximum_activity_date: maximum_created_date,
          page_size: page_size,
          activity_types: [%{id: copper_id, category: copper_type}]
        })

      {:error, :timeout} ->
        fetch_a_page(%{
          url: url,
          page_number: page_number,
          minimum_activity_date: minimum_created_date,
          maximum_activity_date: maximum_created_date,
          page_size: page_size,
          activity_types: [%{id: copper_id, category: copper_type}]
        })
    end
  end

  def maybe_pipeline_ids(map, pipeline_ids) when is_nil(pipeline_ids), do: map

  def maybe_pipeline_ids(map, pipeline_ids) do
    Map.put_new(map, :pipeline_ids, pipeline_ids)
  end

  def maybe_status_ids(map, status_ids) when is_nil(status_ids), do: map

  def maybe_status_ids(map, status_ids) do
    Map.put_new(map, :status_ids, status_ids)
  end

  defp handle_success(response, %{
         url: url,
         page_number: page_number,
         minimum_created_date: minimum_created_date,
         maximum_created_date: maximum_created_date,
         page_size: page_size,
         pipeline_ids: pipeline_ids,
         status_ids: status_ids
       }) do
    items = response.body

    total_pages =
      get_total_no_of_pages(
        get_total_no_of_results(response),
        page_size
      )

    next_page_params =
      cond do
        total_pages - page_number <= 0 ->
          nil

        total_pages - page_number > 0 ->
          %{
            url: url,
            page_number: page_number + 1,
            page_size: page_size,
            minimum_created_date: minimum_created_date,
            maximum_created_date: maximum_created_date,
            pipeline_ids: pipeline_ids,
            status_ids: status_ids
          }
      end

    {items, next_page_params}
  end

  defp handle_success(response, %{
         url: url,
         page_number: page_number,
         minimum_activity_date: minimum_created_date,
         maximum_activity_date: maximum_created_date,
         page_size: page_size,
         activity_types: [%{id: copper_id, category: copper_type}]
       }) do
    items = response.body

    total_pages =
      get_total_no_of_pages(
        get_total_no_of_results(response),
        page_size
      )

    next_page_params =
      cond do
        total_pages - page_number <= 0 ->
          nil

        total_pages - page_number > 0 ->
          %{
            url: url,
            page_number: page_number + 1,
            page_size: page_size,
            minimum_activity_date: minimum_created_date,
            maximum_activity_date: maximum_created_date,
            activity_types: [%{id: copper_id, category: copper_type}]
          }
      end

    {items, next_page_params}
  end

  defp get_total_no_of_pages(no_of_results, page_size) do
    whole_pages = div(no_of_results, page_size)
    remaining_pages = rem(no_of_results, page_size)

    cond do
      remaining_pages > 0 ->
        whole_pages + 1

      remaining_pages == 0 ->
        whole_pages
    end
  end

  defp get_total_no_of_results(%Tesla.Env{} = response) do
    Tesla.get_header(response, "x-pw-total") |> String.to_integer()
  end
end
