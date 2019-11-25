# Test inversion from Notebook 4
t,p = 295.15, 1e5
qsa,β = 1.66e-5, 1/5
r₁,r₂,l = 9.37e-3,1.961e-2,0.44369
leff = 13.0
m = 3
Λ = DMAconfig(t,p,qsa,qsa/β,r₁,r₂,l,leff,:-,m,:cylindrical)
bins,z₁,z₂ = 128, dtoz(Λ,1000e-9), dtoz(Λ,10e-9)
δ = setupDMA(Λ, z₁, z₂, bins);


𝐀=(hcat(map(i->Σ(k->δ.Ω(Λ,δ.Z,i/k).*δ.Tc(k,δ.Dp).*δ.Tl(Λ,δ.Dp),Λ.m),δ.Z)...))'
@test round.(sum(𝐀),digits=2) == 77.38
@test 𝐀 == δ.𝐀

T = (zˢ,k,Λ,δ) -> δ.Ω(Λ,δ.Z,zˢ/k).*δ.Tc(k,δ.Dp).*δ.Tl(Λ,δ.Dp)
𝐀=(hcat(map(zˢ->Σ(k->T(zˢ,k,Λ,δ),Λ.m),δ.Z)...))'
@test round.(sum(𝐀),digits=2) == 77.38
