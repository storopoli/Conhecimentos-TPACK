using Arrow
using CSV
using DataFrames
using Statistics

df = Arrow.Table(joinpath(pwd(), "data", "data.arrow")) |> DataFrame

# Geral
describe(df, :mean, :median, :q25, :q75, :std, :min, :max) |>
    CSV.write(joinpath(pwd(), "tables", "summary.csv"))
