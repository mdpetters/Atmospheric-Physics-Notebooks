# Test Coagulation
t,p = 295.15, 1e5
qsa,β = 1.66e-5, 1/10
r₁,r₂,l = 9.37e-3,1.961e-2,0.44369
leff = 13.0
n = 3
Λ₁ = DMAconfig(t,p,qsa,qsa/β,r₁,r₂,l,leff,:-,n,:cylindrical)
Λ₂ = DMAconfig(t,p,qsa,qsa/β,r₁,r₂,l,leff,:+,n,:cylindrical)
bins,z₁,z₂ = 512, dtoz(Λ₁,250e-9),dtoz(Λ₁,20e-9)
δ₁ = setupDMA(Λ₁, z₁, z₂, bins);
δ₂ = setupDMA(Λ₂, z₁, z₂, bins);

Dₘ = 50.0
zˢ = dtoz(Λ, Dₘ*1e-9);
β₁₂ = map(k->β12(ztod(Λ₁,k,zˢ)*1e-9, ztod(Λ₂,k,zˢ)*1e-9, k,-k),1:n)
@test round.(β₁₂.*1e15,digits=2) == [2.56, 5.34, 8.58]

Dₘ = 100.0
zˢ = dtoz(Λ, Dₘ*1e-9);
βᵣ = β12brown(ztod(Λ₁,1,zˢ)*1e-9, ztod(Λ₂,1,zˢ)*1e-9)
β₁₂ = β12(ztod(Λ,1,zˢ)*1e-9, ztod(Λ,1,zˢ)*1e-9,0,0)
@test βᵣ == β₁₂
