using PyCall, Gadfly, Printf

g = 9.81
cp = 1005.0
Lv = 2.25e6
Rd = 287.05
Rv = 461.5
p0 = 1000.0
eps = Rd/Rv
T = 280.0
alpha1 = 100.0*( eps * Lv * g / (Rd * T^2.0 * cp) - g/(Rd*T))

function pmodel(N,V)
      pm = pyimport("pyrcel")

      T0 = 280.0
      S0 = -0.02
      P0 = 100000.0
      accom=1.0
      

      dist = pm.Lognorm(mu=0.05, sigma=2.0, N=N)
      aer =  pm.AerosolSpecies("ammonium sulfate", dist, kappa=0.6, bins=10)
      model = pm.ParcelModel([aer,], V, T0, S0, P0, accom=accom, console=false)
      parcel_trace, aer_out = model.run(t_end=300.0/V, output_dt=1.0/V, solver="cvode", output="dataframes", terminate=false)
      z  = parcel_trace.z.values
      T  = parcel_trace.T.values
      wc = parcel_trace.wc.values.*1000.0
      S  = parcel_trace.S.values.*100.0
      z,T,wc,S
end

@manipulate for w =  [0.1:0.1:0.9;1:1:20]
      Gadfly.set_default_plot_size(24Gadfly.cm, 15Gadfly.cm)

      xtlabel = -1:0.5:1.5
      ytlabel = -20:20:200
      lfunx = x->ifelse(sum(x .== xtlabel) == 1, @sprintf("%.1f", x), "")
      lfuny = x->ifelse(sum(x .== ytlabel) == 1, @sprintf("%i", x), "")
      zarr = 0.0:1:200.0
      z,T,wc,S = pmodel(500.0, w)
      zLCL = (z[S .> 0.0])[1]

      layers = []
      push!(layers, layer(x =-2.0 .+ alpha1.*zarr, y = zarr .- zLCL, Geom.line, Theme(line_style=[:dash]),
                  color = ["S = α₁*z" for i = 1:length(zarr)]))

      push!(layers, layer(x = S, y = z .- zLCL, Geom.line(preserve_order=true), 
            color = ["S(z)" for i = 1:length(S)]))

      push!(layers, layer(x = [-1,2], y = [0,0], Geom.line, 
            color = ["LCL" for i = 1:2]))

      push!(layers, layer(x = [0,0], y = [-30,210], Geom.line, 
            color = ["LCL" for i = 1:2]))

      guides = []
      push!(guides, Guide.xlabel("Supersaturation (%)"))
      push!(guides, Guide.ylabel("Height above LCL (m)"))
      push!(guides, Guide.title("Supersaturation Profile"))
      push!(guides, Guide.xticks(ticks=-1:0.1:2))
      push!(guides, Guide.yticks(ticks=-20:10:200))

      scales = []
      push!(scales, Scale.x_continuous(labels = lfunx))
      push!(scales, Scale.y_continuous(labels = lfuny))
      push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

      coords = []    
      push!(coords,Coord.cartesian(xmin=-1, xmax=1.5, ymin = -20, ymax = 200.0))

      p1 = plot(layers..., guides...,scales...,coords...)
      hstack(p1,p1)
end