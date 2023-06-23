defmodule SkylineOperations.Queries do
  import Ecto.Query

  def get_installs_by_dates(beginning, ending) do
    from(o in CopperApi.Schemas.Opportunity,
      where:
        (o.install_date >= ^beginning and o.install_date <= ^ending) or
          (o.install_completed_date >= ^beginning and o.install_completed_date <= ^ending) or
          (o.install_funded_date >= ^beginning and o.install_funded_date <= ^ending),
      select: o
    )
  end
end
