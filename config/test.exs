use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :book4less, Book4LessWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :book4less, Book4Less.Repo,
  username: "postgres",
  password: "postgres",
  database: "book4less_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
