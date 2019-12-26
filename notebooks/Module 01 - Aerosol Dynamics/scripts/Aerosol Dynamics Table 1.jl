using DifferentialMobilityAnalyzers, DataFrames, WebIO

function aerosol_table1()
    𝕟 = lognormal([[200.0, 80.0, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10)

    Dp = (𝕟.De[2:end]+𝕟.De[1:end-1])/2.0
    Dlow = round.(Int,𝕟.De[1:end-1])
    Dup = round.(Int,𝕟.De[2:end])
    N = round.(Int,𝕟.N)
    S=π.*(Dp.*1e-3).^2.0.*N
    V=π./6.0*(Dp.*1e-3).^3.0.*N
    M=π./6.0*(Dp.*1e-3).^3.0.*N.*2.0

    df = DataFrame(Dlow=Dlow,Dup=Dup,N=N)
end

display(aerosol_table1())