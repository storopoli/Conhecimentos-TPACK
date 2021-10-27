using Arrow
using CSV
using DataFrames

function csv2arrow_enade(year)
    Arrow.write(
        joinpath(pwd(), "data", "ENADE", "MICRODADOS_ENADE_$(year).arrow"),
        CSV.read(
            joinpath(pwd(), "data", "ENADE", "MICRODADOS_ENADE_$(year).txt"),
            DataFrame;
            delim=';',
            decimal=',',
            missingstring=["", "NA"],
            types=Dict(:DS_VT_ACE_OFG => String, :DS_VT_ACE_OCE => String),
        );
        compress=:lz4,
    )
    return nothing
end

function csv2arrow_censo(year)
    for dm in ["ALUNO", "IES", "LOCAL_OFERTA", "DOCENTE", "CURSO"]
        Arrow.write(
            joinpath(pwd(), "data", "Censo", "DM_$(dm)_$(year).arrow"),
            CSV.read(
                joinpath(pwd(), "data", "Censo", "DM_$(dm)_$(year).csv"),
                DataFrame;
                delim='|',
                decimal=',',
                missingstring=["", "NA"],
            );
            compress=:lz4,
        )
    end
    return nothing
end

map(csv2arrow_enade, 2015:2019)
map(csv2arrow_censo, 2015:2019)
