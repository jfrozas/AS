defmodule Fic_sports.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:name, :string)
      add(:category, :string)
      add(:price, :float)
      add(:brand, :string)
      add(:stock, :integer)
    end
  end
end
