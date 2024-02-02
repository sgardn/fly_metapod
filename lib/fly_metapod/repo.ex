defmodule FlyMetapod.Repo do
  use Ecto.Repo,
    otp_app: :fly_metapod,
    adapter: Ecto.Adapters.Postgres
end
