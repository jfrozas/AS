import Config

config :fic_sports, Fic_sports.Repo,
  database: "fic_sports_repo",
  username: "postgres",
  password: "user",
  hostname: "localhost"

config :fic_sports, ecto_repos: [Fic_sports.Repo]
