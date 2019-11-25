T,p = 293.15, 1e5
qsa,β = 1.6666666e-5, 1/10
r1,r2,l = 9.37e-3,1.961e-2,0.44369
leff = 13.0
n = 6.0
Λ = DMAconfig(T,p,qsa,qsa/β,r1,r2,l,leff,:-,n,:cylindrical)
bins,z1,z2 = 128, dtoz(Λ,1000e-9), dtoz(Λ,10e-9)
δ = setupDMA(Λ, z1, z2, bins);

@test typeof(Λ) == DMAconfig
@test typeof(δ) == DifferentialMobilityAnalyzer

v = 1000         # 1000 V
z = vtoz(Λ,v)    # Get mobility
@test round(Int, ztod(Λ,1,z)) == 77  # 1 charge
@test round(Int, ztod(Λ,2,z)) == 114 # 2 charges
@test round(Int, ztod(Λ,3,z)) == 145 # 3 charges
z = vtoz(Λ,[v,v])
@test round.(Int, ztod(Λ,1,z)) == [77, 77]

@test round(cc(Λ, 100e-9),digits=2) == 2.96  # Cunningham at 100 nm
@test round(cc(Λ, 10e-9),digits=2) == 23.27  # Cunningham at 10 nm
@test round.(cc(Λ, [100.0,10.0].*1e-9),digits=2) == [2.96, 23.27] # array working
@test round.(δ.Tl(Λ,[10.0,30.0]),digits=2) == [0.51, 0.86]

Λ = DMAconfig(T,p,qsa,qsa/β,r1,r2,l,leff,:-,n,:cylindrical)
δ = setupDMA(Λ, z1, z2, bins);
charge = hcat(map(k->δ.Tc(k,δ.Dp), 1:6)...)
charge[10,:]   # Test + carging at 618 n,
@test round.(charge[10,:], digits=3) == [0.126, 0.085,0.048, 0.022, 0.008,0.003]

Λ = DMAconfig(T,p,qsa,qsa/β,r1,r2,l,leff,:+,n,:cylindrical)
δ = setupDMA(Λ, z1, z2, bins);
charge = hcat(map(k->δ.Tc(k,δ.Dp), 1:6)...)
charge[10,:]   # Test - carging at 618 n,
@test round.(charge[10,:], digits=3) == [0.164, 0.144,0.048, 0.022, 0.008,0.003]

zˢ = dtoz(Λ, 200e-9)
@test round(δ.Ω(Λ,zˢ,zˢ),digits=2) == 0.97
zˢ = dtoz(Λ, 20e-9)
@test round(δ.Ω(Λ,zˢ,zˢ),digits=2) == 0.76


T,p = 293.15, 1e5
qsa,β = 1.6666666e-5, 1/4
r1,r2,l = 9.37e-3,1.961e-2,0.44369
leff = 13.0
n = 6.0
Λ = DMAconfig(T,p,qsa,qsa/β,r1,r2,l,leff,:-,n,:cylindrical)
v1,v2 = 10,10000
tscan, tc = 120,1
z1,z2 = vtoz(Λ,v2), vtoz(Λ,v1)
δ = setupSMPS(Λ, v1, v2, tscan, tc);
@test round(sum(δ.𝐀),digits=1) == 95.8
