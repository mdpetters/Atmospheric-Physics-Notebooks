using PyCall, Gadfly

pm = pyimport("pyrcel")

V = 1.0
T0 = 279.0
S0 = -0.1
P0 = 100000.0
accom=0.1

dist = pm.Lognorm(mu=0.05, sigma=2.0, N=100.0)
aer =  pm.AerosolSpecies("ammonium sulfate", dist, kappa=0.7, bins=100)
model = pm.ParcelModel([aer,], V, T0, S0, P0, accom=accom, console=false)
parcel_trace, aer_out = model.run(t_end=2500., dt=1.0, solver="cvode", output="dataframes", terminate=true)
z = (parcel_trace[:z])[:values]
S = (parcel_trace[:S])[:values]
