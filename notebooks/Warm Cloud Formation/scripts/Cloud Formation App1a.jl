using PyCall, Gadfly

pm = pyimport("pyrcel")

V = 1.0
T0 = 279.0
S0 = -0.05
P0 = 100000.0
accom=0.1

dist = pm.Lognorm(mu=0.05, sigma=2.0, N=100.0)
aer =  pm.AerosolSpecies("ammonium sulfate", dist, kappa=0.7, bins=100)
model = pm.ParcelModel([aer,], V, T0, S0, P0, accom=accom, console=false)
parcel_trace, aer_out = model.run(t_end=500., dt=1.0, solver="cvode", output="dataframes", terminate=false)
z = (parcel_trace[:z])[:values]
T = (parcel_trace[:T])[:values]
wc = (parcel_trace[:wc])[:values].*1000.0
S = (parcel_trace[:S])[:values].*100.0
parcel_trace

layers = []
push!(layers, layer(x = S, y = z, Geom.line(preserve_order=true), 
      color = ["S(z)" for i = 1:length(S)]))

guides = []
push!(guides, Guide.xlabel("Supersaturation (%)"))
push!(guides, Guide.ylabel("Height (m)"))
push!(guides, Guide.title("Supersaturation Profile"))
#push!(guides, Guide.xticks(ticks=xticks))
#push!(guides, Guide.yticks(ticks=yticks))

scales = []
#push!(scales, Scale.x_log10(labels = lfunx))
#push!(scales, Scale.y_log10(labels = lfuny))
push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

coords = []    
#push!(coords,Coord.cartesian(xmin=log10(0.008), xmax=log10(2.0), ymin = log10(8), ymax = log10(3000)))

p1 = plot(layers..., guides...,scales...,coords...)
