using Gadfly, CSV, DataFrames, SpecialFunctions

function ulbricht1(D,R,μ)
	N₀(μ) = 6e3*0.1^μ*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = 10.0*(3.67 + μ)*(2e6*exp(3.2*μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*RR^δ
	N₀(μ)*D^μ*exp(-Λ(μ,D₀)*D)
end

RR = 1.0
μ = 0.5
De = collect(0:0.8:4.0)
Dm = (De[2:end]-De[1:end-1])/2 + De[1:end-1]
df = DataFrame()
df[!,:Dlow] = De[1:end-1]
df[!,:Dmid] = Dm
df[!,:Dup] = De[2:end]
df[!,:SpectralDensity] = ulbricht1.(Dm,RR,μ)
df[!,:N] = ulbricht1.(Dm,RR,μ).*(df[!,:Dup]-df[!,:Dlow])
df[!,:N] = [nothing for i = 1:length(Dm)]

display(df)