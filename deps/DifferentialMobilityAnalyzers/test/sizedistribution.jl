using SpecialFunctions, LinearAlgebra

T,p = 293.15, 1e5
qsa,β = 1.6666666e-5, 1/10
r1,r2,l = 9.37e-3,1.961e-2,0.44369
leff = 13.0
n = 6.0
Λ = DMAconfig(T,p,qsa,qsa/β,r1,r2,l,leff,:-,n,:cylindrical)
bins,z1,z2 = 128, dtoz(Λ,1000e-9), dtoz(Λ,10e-9)
δ = setupDMA(Λ, z1, z2, bins);

𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10);
@test 𝕟.form == :lognormal
@test round(Int,𝕟.De[end]) == 300

𝕟 = DMALognormalDistribution([[400, 80, 1.3]], δ)
@test round(Int,sum(𝕟.N)) == 400
@test 𝕟.form == :DMA

𝕥 = triangular(Λ, δ, [400, 150])
@test 𝕥.form == :DMA
@test round(Int, 𝕥.Dp[argmax(𝕥.N)]) == 147

𝕟 = 1.5*𝕥
@test round(Int,sum(𝕟.N)) == 600

𝕟 = lognormal([[100, 100, 1.1]]; d1 = 10.0, d2 = 1000.0, bins = 256);
μ,σ = 100.0, 200.0
T = 0.5*(1.0 .+ erf.((𝕟.Dp .- μ)./sqrt(2σ)))
𝕩 = T * 𝕟
@test round(Int,sum(𝕟.N)) == 100

# Add test later
𝕟 = DMALognormalDistribution([[130, 50, 1.3], [280, 140, 1.9]], δ);
𝕩 = δ.𝐀*𝕟
# Add test later

𝕟₁ = lognormal([[120, 90, 1.10]]; d1 = 10.0, d2 = 1000.0, bins = 256);
𝕟₂ = lognormal([[90, 110, 1.15]]; d1 = 10.0, d2 = 1000.0, bins = 256);
𝕩 = 𝕟₁ * 𝕟₂
@test round(Int,sum(𝕩.N)) == 120*90

𝕟₁ = lognormal([[120, 90, 1.20]]; d1 = 10.0, d2 = 1000.0, bins = 256);
𝕟₂ = deepcopy(𝕟₁)
𝕟₂.N[𝕟₂.Dp .<= 90] .= 0
𝕟₂.S[𝕟₂.Dp .<= 90] .= 0
𝕩 = 𝕟₂/𝕟₁
@test round(Int,sum(𝕩.N)) == 134

a = 1.4
𝕟 = lognormal([[100, 100, 1.1]]; d1 = 10.0, d2 = 1000.0, bins = 256);
𝕩 = a ⋅ 𝕟
@test round(𝕩.Dp[argmax(𝕩.N)]/𝕟.Dp[argmax(𝕟.N)],digits=1) == a

𝕟 = DMALognormalDistribution([[100, 100, 1.1]], δ);
𝕩 = a ⋅ 𝕟
@test round(𝕩.Dp[argmax(𝕩.N)]/𝕟.Dp[argmax(𝕟.N)],digits=1) == a

𝕟 = lognormal([[100, 100, 1.1]]; d1 = 10.0, d2 = 1000.0, bins = 256);
μ,σ = 80.0, 2000.0
T = (1.0 .+ erf.((𝕟.Dp .- μ)./(sqrt(2σ))))
𝕩 = T ⋅ 𝕟
@test round(Int, sum(𝕩.N)) == 218

𝕟 = DMALognormalDistribution([[100, 100, 1.1]], δ);
T = (1.0 .+ erf.((𝕟.Dp .- μ)./(sqrt(2σ))))
𝕩 = T ⋅ 𝕟
@test round(Int, sum(𝕩.N)) == 209

𝕟₂ = lognormal([[90, 140, 1.15]]; d1 = 20.0, d2 = 800.0, bins = 64);
𝕩 = 𝕟₁+𝕟₂
@test round(Int, sum(𝕩.N)) == 210
𝕩 = 𝕟₁+𝕟₁
@test round(Int, sum(𝕩.N)) == 240
