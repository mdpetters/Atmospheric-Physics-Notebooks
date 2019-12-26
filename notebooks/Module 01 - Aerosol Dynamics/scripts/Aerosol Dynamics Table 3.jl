using DifferentialMobilityAnalyzers, DataFrames

function aerosol_table3()
    𝕟 = lognormal([[200.0, 80.0, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10)

    D1 = round.(Int,(𝕟.De[2:end]+𝕟.De[1:end-1])/2.0)
    Dlow = round.(Int,𝕟.De[1:end-1])
    Dup = round.(Int,𝕟.De[2:end])
    N = round.(Int,𝕟.N)
    S1=round.(π.*(D1.*1e-3).^2.0.*N,digits=3)
    V1=round.(π./6.0*(D1.*1e-3).^3.0.*N,digits=3)
    M1=round.(π./6.0*(D1.*1e-3).^3.0.*N.*2.0, digits = 4)

    Dp = Array{Union{Nothing,Float64}}(undef, 10)
    S = Array{Union{Nothing,Float64}}(undef, 10)
    V = Array{Union{Nothing,Float64}}(undef, 10)
    M = Array{Union{Nothing,Float64}}(undef, 10)
    Dp[1:3] = D1[1:3]
    S[1:3] = S1[1:3]
    V[1:3] = V1[1:3]
    M[1:3] = M1[1:3]
    Dp[7:end] = D1[7:end]
    S[7:end] = S1[7:end]
    V[7:end] = V1[7:end]
    M[7:end] = M1[7:end]

    df = DataFrame(Dlow=Dlow,Dup=Dup,Dp=Dp,N=N,S=S,V=V,M=M)
end

display(aerosol_table3())