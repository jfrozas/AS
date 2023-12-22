defmodule Fic_sports.CSVImporter do
  alias Fic_sports.Products
  alias Fic_sports.Repo

  @moduledoc """
  Modulo con funciones de parse de CSV e insercion a la DB.
  """

  def insert_csv_to_db(file_path) do
    case File.read(file_path) do
      {:ok, data} ->
        parsed = parse_csv(data)
        Enum.each(parsed, &insert_row_to_db/1)

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
    end
  end

  defp parse_csv(data) do
    data
    # Split by lines, adjust for line endings if needed
    |> String.split("\r\n")
    # Split each line by commas (CSV format)
    |> Enum.map(&String.split(&1, ","))
  end

  # alias Fic_sports.CSVImporter
  # CSVImporter.insert_csv_to_db("bd.csv")

  defp insert_row_to_db(row) do
    product_params = %{
      name: Enum.at(row, 0),
      category: Enum.at(row, 1),
      price: String.to_float(Enum.at(row, 2)),
      brand: Enum.at(row, 3),
      stock: String.to_integer(Enum.at(row, 4))
    }

    changeset = Products.changeset(%Products{}, product_params)

    case Repo.insert(changeset) do
      {:ok, _record} ->
        IO.puts("Data inserted successfully")

      {:error, _} ->
        IO.puts("Failed to insert data")
    end
  end

  def reset_bd(file_path) do
    Fic_sports.Repo.delete_all(Fic_sports.Products)
    # Reinicia la secuencia de ID
    # Fic_sports.CSVImporter.reset_bd("bd.csv")
    Fic_sports.Repo.query!("ALTER SEQUENCE products_id_seq RESTART WITH 1")
    insert_csv_to_db(file_path)
  end
end
