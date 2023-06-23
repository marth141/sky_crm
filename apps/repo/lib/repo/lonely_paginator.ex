defmodule Repo.LonelyPaginator do
  @moduledoc """
  A stand-alone paginator module for building and executing paginated ecto queries.
  """
  import Ecto.Query, warn: false

  @doc """
  Adjusts a query for limit/offset using page/per_page options.

  Does not execute a query or calculate pagination details.
  """
  def paginate_query(query, page: page, per_page: per_page)
      when is_integer(page) and is_integer(per_page) do
    query
    |> limit(^per_page)
    |> offset(^(per_page * (page - 1)))
  end

  def paginate_query(query, %{"page" => page, "per_page" => per_page})
      when is_integer(page) and is_integer(per_page) do
    paginate_query(query, page: page, per_page: per_page)
  end

  def paginate_query(query, _opts), do: query

  @doc """
  Executes a paginated query against a given repo based on pagination options.
  """
  def paginate(query, repo, [page: page, per_page: per_page] = opts)
      when is_integer(page) and is_integer(per_page) do
    results =
      query
      |> paginate_query(opts)
      |> repo.all()

    calculate_pagination_details(repo, query, results, page, per_page)
  end

  def paginate_query(query, repo, %{"page" => page, "per_page" => per_page})
      when is_integer(page) and is_integer(per_page) do
    paginate(repo, query, page: page, per_page: per_page)
  end

  @doc """
  Calculates pagination details based on the `repo` provided.

  If the first response value has a `total_count` value it will use that.
    (for more expensive queries you may want to integrate the row counts in a window select).
  """
  def calculate_pagination_details(repo, query, results, page, per_page) do
    has_next = length(results) > per_page
    has_prev = page > 1

    count = total_count(repo, query, results)
    page_count = ceil(count / per_page)
    next_page = if page + 1 <= page_count, do: page + 1, else: nil

    %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      page: page,
      page_count: ceil(count / per_page),
      next_page: next_page,
      first: (page - 1) * per_page + 1,
      last: Enum.min([page * per_page, count]),
      count: count,
      data: Enum.slice(results, 0, per_page)
    }
  end

  defp total_count(_repo, _query, [%{total_count: total_count} | _] = _result), do: total_count

  defp total_count(repo, query, _result) do
    repo.one(from(t in subquery(exclude(query, :preload)), select: count("*")))
  end
end
