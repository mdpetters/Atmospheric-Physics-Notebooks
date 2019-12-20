using Gadfly, CSV, DataFrames, NumericIO, SpecialFunctions

function ulbricht(D,R,μ)
	N₀(μ) = 6e4*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = (3.67 + μ)*(33.31*N₀(μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*RR^δ
	N₀(μ)*D^μ*exp(-Λ(μ,D₀)*D)./10.0
end

function ulbricht1(D,R,μ)
	N₀(μ) = 6e3*0.1^μ*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = 10.0*(3.67 + μ)*(2e6*exp(3.2*μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*R^δ
	N₀(μ)*D^μ*exp(-Λ(μ,D₀)*D)
end

function moments(R,μ)
	N₀(μ) = 6e3*0.1^μ*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = 10.0*(3.67 + μ)*(2e6*exp(3.2*μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*R^δ
	N = gamma(1.0+μ)/(3.67+μ)^(1.0+μ) * N₀(μ) * D₀^(1.0+μ)
	RWC = 5.24e-4*gamma(4.0+μ)/(3.67+μ)^(4.0+μ) * N₀(μ) * D₀^(4.0+μ)
	R = 7.1265e-3*gamma(4.67+μ)/(3.67+μ)^(4.67+μ) * N₀(μ) * D₀^(4.67+μ)
	Z = gamma(7.0+μ)/(3.67+μ)^(7.0+μ) * N₀(μ) * D₀^(7.0+μ)
	N,RWC,R,Z
end

function momentsorig(R,μ)
	N₀(μ) = 6e4*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = (3.67 + μ)*(33.31*N₀(μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*R^δ
	N = gamma(1.0+μ)/(3.67+μ)^(1.0+μ) * N₀(μ) * D₀^(1.0+μ)
	RWC = 0.524*gamma(4.0+μ)/(3.67+μ)^(4.0+μ) * N₀(μ) * D₀^(4.0+μ)
	R = 33.31*gamma(4.67+μ)/(3.67+μ)^(4.67+μ) * N₀(μ) * D₀^(4.67+μ)
	Z = 1e6*gamma(7.0+μ)/(3.67+μ)^(7.0+μ) * N₀(μ) * D₀^(7.0+μ)
	N,RWC,R,Z
end

function rain_app4()
	Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)

	tRR = 3.0
	μ = 0.5
	De = collect(0:0.5:5.0)
	Dm = (De[2:end]-De[1:end-1])/2 + De[1:end-1]
	df = DataFrame()
	df[!,:Dlow] = De[1:end-1]
	df[!,:Dmid] = Dm
	df[!,:Dup] = De[2:end]
	S = ulbricht1.(Dm,tRR,μ)
	N = S.*(df[!,:Dup]-df[!,:Dlow])
	LWC = N.*π/6.0.*(Dm*1e-3).^3.0.*997.1 * 1000.0
	RR = N.*π/6.0.*(Dm*1e-3).^3.0 *3.778.* Dm.^0.67 * 3600.0 * 1000.0
	Z = N.*Dm.^6.0 
	# Ni = moments(tRR,μ)
	# No = momentsorig(tRR,μ)
	# println((sum(N),sum(LWC),sum(RR),sum(Z))," ",Ni," ", No)
	df[!,:S] = map(x->formatted(x, :SCI, ndigits=2), S)
	Nx = Array{Union{Nothing,String}}(undef, length(Dm))
	Rx = Array{Union{Nothing,String}}(undef, length(Dm))
	RWCx = Array{Union{Nothing,String}}(undef, length(Dm))
	Zx = Array{Union{Nothing,String}}(undef, length(Dm))
	dBZx = Array{Union{Nothing,String}}(undef, length(Dm))

	Nx[1:end] = map(x->formatted(x, :SCI, ndigits=2), N)
	Rx[1:end] = map(x->formatted(x, :SCI, ndigits=2), RR)
	RWCx[1:end] = map(x->formatted(x, :SCI, ndigits=2), LWC)
	Zx[1:end] = map(x->formatted(x, :SCI, ndigits=2), Z)
	dBZx[1:end] = map(x->formatted(x, :SI, ndigits=3), 10*log10.(Z))
	i = 4
	j = 5

	df[!,:N] = Nx
	df[!,:R] = Rx
	df[!,:RLWC] = RWCx
	df[!,:Z] = Zx
	df[!,:dBZ] = dBZx

	df[i:j,5:end] .= nothing
	display(df)
end

rain_app4()