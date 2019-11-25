# +
# This file handles binned size distribution from size distribution functions
#
# Author: Markus Petters (mdpetter@ncsu.edu)
# 	      Department of Marine Earth and Atmospheric Sciences
#         NC State University
#         Raleigh, NC 27605
#
#         April, 2018
#-

# λ functions
md = (A,x) -> @. A[1]/(√(2π)*log(A[3]))*exp(-(log(x/A[2]))^2/(2log(A[3])^2))
logn = (A,x) -> mapreduce((A) -> md(A,x), +, A)
clean = x -> map(x -> x < 0.0 ? 0.0 : x, x)

# Multimodal lognormal size distribution on a generic logspace grid
function lognormal(A; d1 = 8.0, d2 = 2000.0, bins = 256)
	#De = logspace(log10(d1), log10(d2), bins+1)
	De = 10.0 .^ range(log10(d1), stop=log10(d2), length=bins+1)
	Dp = sqrt.(De[2:end].*De[1:end-1])
	ΔlnD = log.(De[2:end]./De[1:end-1])
	S = logn(A, Dp)
	N = S.*ΔlnD
	return SizeDistribution(A,De,Dp,ΔlnD,S,N,:lognormal)
end

# Triangular size distribution for a given diameter and number concentration
function triangular(Λ::DMAconfig, δ::DifferentialMobilityAnalyzer, A)
	Nt = A[1]
	zˢ = dtoz(Λ,A[2].*1e-9)
	Ntrans = Ω(Λ,δ.Z,zˢ)  # Transfer function with peak at 1
	N = Nt.*Ntrans./sum(Ntrans)
	S = N./δ.ΔlnD
	return SizeDistribution([A],reverse(δ.De),reverse(δ.Dp),reverse(δ.ΔlnD),
							reverse(S),reverse(N),:DMA)
end

# Lognormal distrubution on a DMA size grid
function DMALognormalDistribution(A, δ::DifferentialMobilityAnalyzer)
	S = logn(A, δ.Dp)

	return SizeDistribution(A, δ.De, δ.Dp, δ.ΔlnD, S,S.*δ.ΔlnD,:DMA)
end

# -------------------------- Size Distribution Arithmetic ---------------------
# --------------------------- Block 1: * .* and ./  ---------------------------
function *(a::Float64, 𝕟::SizeDistribution)
	# This function defines the product of a scalar and a size distribution
	N = a * 𝕟.N
	S = a * 𝕟.S

	return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,S,N,:axdist)
end


function *(a::Array{Float64,1}, 𝕟::SizeDistribution)
	# This function defines the product of a vector and a size distribution
	N = a .* 𝕟.N
	S = a .* 𝕟.S
	return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,S,N,:axdist)
end

function *(𝐀::Array{Float64,2}, 𝕟::SizeDistribution)
	# This function defines the product of a matrix and a size distribution
	N = 𝐀 * 𝕟.N
	S = 𝐀 * 𝕟.S
	return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,S,N,:axdist)
end

function *(𝕟₁::SizeDistribution, 𝕟₂::SizeDistribution)
	# This function defines the product of two size distributions
	Nsq = 𝕟₁.N .* 𝕟₂.N
	N = sum(𝕟₁.N)*sum(𝕟₂.N)*Nsq./sum(Nsq)
	S = N./𝕟₁.ΔlnD
	return SizeDistribution([[]],𝕟₁.De,𝕟₁.Dp,𝕟₁.ΔlnD,S,N,:dist_sq)
end


function /(𝕟₁::SizeDistribution, 𝕟₂::SizeDistribution)
	# This function defines the product of two size distributions
	N = 𝕟₁.N ./ 𝕟₂.N
	S = 𝕟₁.S./𝕟₂.S
	return SizeDistribution([[]],𝕟₁.De,𝕟₁.Dp,𝕟₁.ΔlnD,S,N,:dist_sq)
end


# --------------------------- Block 2: ⋅ and .⋅  -----------------------------
function LinearAlgebra.:⋅(a::Float64, 𝕟::SizeDistribution)
	if 𝕟.Dp[1] > 𝕟.Dp[2]
		nDp = reverse(a * 𝕟.Dp)
		itpN = interpolate((nDp,),reverse(𝕟.N),Gridded(Linear()))
		extN = extrapolate(itpN,0)

		itpS = interpolate((nDp,),reverse(𝕟.S),Gridded(Linear()))
		extS = extrapolate(itpS,0)
		N = clean(extN(reverse(𝕟.Dp)))
		S = clean(extS(reverse(𝕟.Dp)))
		N = S.*reverse(𝕟.ΔlnD)
		return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,reverse(S),
					reverse(N),:axdist)
	else
		nDp = a * 𝕟.Dp
		itpN = interpolate((nDp,),reverse(𝕟.N),Gridded(Linear()))
		extN = extrapolate(itpN,0)

		itpS = interpolate((nDp,),reverse(𝕟.S),Gridded(Linear()))
		extS = extrapolate(itpS,0)
		N = clean(extN(𝕟.Dp))
		S = clean(extS(𝕟.Dp))

		N = S.*𝕟.ΔlnD
		return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,S,N,:axdist)
	end
end

#function LinearAlgebra.:.⋅(A::Array{Float64,1}, 𝕟::SizeDistribution)
function LinearAlgebra.:⋅(A::Array{Float64,1}, 𝕟::SizeDistribution)
	if 𝕟.Dp[1] > 𝕟.Dp[2]
		nDp = reverse(A .* 𝕟.Dp)
		itpN = interpolate((nDp,),reverse(𝕟.N),Gridded(Linear()))
		extN = extrapolate(itpN,0)

		itpS = interpolate((nDp,),reverse(𝕟.S),Gridded(Linear()))
		extS = extrapolate(itpS,0)
		N = clean(extN(reverse(𝕟.Dp)))
		S = clean(extS(reverse(𝕟.Dp)))

		return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,reverse(S),
					reverse(N),:axdist)
	else
		nDp = A .* 𝕟.Dp
		itpN = interpolate((nDp,),reverse(𝕟.N),Gridded(Linear()))
		extN = extrapolate(itpN,0)

		itpS = interpolate((nDp,),reverse(𝕟.S),Gridded(Linear()))
		extS = extrapolate(itpS,0)
		N = clean(extN(𝕟.Dp))
		S = clean(extS(𝕟.Dp))

		return SizeDistribution([[]],𝕟.De,𝕟.Dp,𝕟.ΔlnD,S,N,:axdist)
	end
end

# --------------------------- Block 3: +-------------------------------------
function +(𝕟₁::SizeDistribution, 𝕟₂::SizeDistribution)
	# This function defines the sum of two size distributions

	# If grids are not equal, then interpolate n2 onto n1 grid
	if 𝕟₁.Dp ≠ 𝕟₂.Dp
		itp = interpolate((𝕟₂.Dp,),𝕟₂.N,Gridded(Linear()))
		ext = extrapolate(itp,0)
		N = clean(ext(𝕟₁.Dp))

		itp = interpolate((𝕟₂.Dp,),𝕟₂.S,Gridded(Linear()))
		ext = extrapolate(itp,0)
		S = clean(ext(𝕟₁.Dp))
		S = 𝕟₁.S + S
	else
		S = 𝕟₁.S + 𝕟₂.S
	end
	N = S.*𝕟₁.ΔlnD
	return SizeDistribution([[]],𝕟₁.De,𝕟₁.Dp,𝕟₁.ΔlnD,S,N,:distsum)
end
