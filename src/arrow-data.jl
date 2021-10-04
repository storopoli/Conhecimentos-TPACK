using Arrow
using CSV
using DataFrames

# For loop is complicated because files
# are not consistent
df2015 = CSV.read(joinpath(pwd(), "data", "MICRODADOS_ENADE_2015.txt"), DataFrame;
                  delim=';', missingstring=["", "NA"],
                  types=Dict(
                            :DS_VT_ACE_OFG => String,
                            :DS_VT_ACE_OCE => String))
Arrow.write(joinpath(pwd(), "data", "MICRODADOS_ENADE_2015.arrow"), df2015; compress=:lz4)

df2016 = CSV.read(joinpath(pwd(), "data", "MICRODADOS_ENADE_2016.txt"), DataFrame;
                  delim=';', missingstring=["", "NA"],
                  types=Dict(
                            :DS_VT_ACE_OFG => String,
                            :DS_VT_ACE_OCE => String))
Arrow.write(joinpath(pwd(), "data", "MICRODADOS_ENADE_2016.arrow"), df2016; compress=:lz4)

df2017 = CSV.read(joinpath(pwd(), "data", "MICRODADOS_ENADE_2017.txt"), DataFrame;
                  delim=';', missingstring=["", "NA"],
                  types=Dict(
                            :DS_VT_ACE_OFG => String,
                            :DS_VT_ACE_OCE => String))
Arrow.write(joinpath(pwd(), "data", "MICRODADOS_ENADE_2017.arrow"), df2017; compress=:lz4)

df2018 = CSV.read(joinpath(pwd(), "data", "MICRODADOS_ENADE_2018.txt"), DataFrame;
                  delim=';', missingstring=["", "NA"],
                  types=Dict(
                            :DS_VT_ACE_OFG => String,
                            :DS_VT_ACE_OCE => String))
Arrow.write(joinpath(pwd(), "data", "MICRODADOS_ENADE_2018.arrow"), df2018; compress=:lz4)

df2019 = CSV.read(joinpath(pwd(), "data", "MICRODADOS_ENADE_2019.txt"), DataFrame;
                  delim=';', decimal=',', missingstring=["", "NA"],
                  types=Dict(
                            :DS_VT_ACE_OFG => String,
                            :DS_VT_ACE_OCE => String))
Arrow.write(joinpath(pwd(), "data", "MICRODADOS_ENADE_2019.arrow"), df2019; compress=:lz4)
