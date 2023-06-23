defmodule ZenefitsApi do
  @moduledoc """
  Documentation for `ZenefitsApi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ZenefitsApi.hello()
      :world

  """
  def hello do
    :world
  end

  defp get_token() do
    Application.fetch_env!(:zenefits_api, :api_token)
  end

  def get_companies() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/companies",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_people(company_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/companies/#{company_id}/people",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_employments(person_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/people/#{person_id}/employments",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_company_bank_accounts(company_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/companies/#{company_id}/company_banks",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_employee_bank_accounts(person_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/people/#{person_id}/banks",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_departments(company_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/companies/#{company_id}/departments",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_locations(company_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/companies/#{company_id}/locations",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_me() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/me",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_labor_group_types() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/labor_group_types",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_labor_groups(labor_group_type_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/labor_group_types/#{labor_group_type_id}/labor_groups",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_custom_fields() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/custom_fields",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_custom_field_values(person_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/core/people/#{person_id}/custom_field_values",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_vacation_requests() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/time_off/vacation_requests",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_vacation_types() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/time_off/vacation_types",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_time_durations() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/time_attendance/time_durations",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_applications() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/platform/applications",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_company_installations() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/platform/company_installs",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_person_subscriptions() do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/platform/person_subscriptions",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end

  def get_flows(subscription_id) do
    with {:ok, %{status: 200, body: body}} <-
           Finch.build(
             :get,
             "https://api.zenefits.com/platform/person_subscriptions/#{subscription_id}/flows",
             [{"Authorization", "Bearer #{get_token()}"}]
           )
           |> Finch.request(ZenefitsFinch) do
      body |> Jason.decode!()
    else
      error -> error
    end
  end
end
