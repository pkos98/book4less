defmodule Book4Less.Repo do
  use Ecto.Repo,
    otp_app: :book4less,
    adapter: Ecto.Adapters.Postgres
end
