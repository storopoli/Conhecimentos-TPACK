using Arrow
using CSV
using DataFrames
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# Geral
CSV.write(joinpath(pwd(), "tables", "summary.csv"))(describe(
    df, :mean, :median, :q25, :q75, :std, :min, :max
))
