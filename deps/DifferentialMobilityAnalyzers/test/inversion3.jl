using Random

# Test inversion from Notebook 5
t,p = 295.15, 1e5
qsa,β = 1.66e-5, 1/5
r₁,r₂,l = 9.37e-3,1.961e-2,0.44369
leff = 13.0
m = 3
Λ = DMAconfig(t,p,qsa,qsa/β,r₁,r₂,l,leff,:-,m,:cylindrical)
bins,z₁,z₂ = 128, dtoz(Λ,1000e-9), dtoz(Λ,10e-9)
δ = setupDMA(Λ, z₁, z₂, bins);

𝕟 = DMALognormalDistribution([[400, 30, 1.2],[500, 110, 1.7]], δ)
Random.seed!(703)
tscan = 120
Qcpc = 16.66
t = tscan./bins

𝕣 = δ.𝐀*𝕟;
c = 𝕣.N*Qcpc*t;
R = Float64[]
for i = c
    f = rand(Poisson(i),1)
    push!(R,f[1]/(Qcpc*t))
end
λ₁,λ₂ = 1e-3, 1e1

rinv(𝕣.N, δ,λ₁=λ₁,λ₂=λ₂)
@test round(Int, sum(𝕟ᵢₙᵥ.N)) == 894
