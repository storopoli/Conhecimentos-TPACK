using Arrow
using DataFrames
using Statistics

df = Arrow.Table(joinpath(pwd(), "data", "data.arrow")) |> DataFrame
