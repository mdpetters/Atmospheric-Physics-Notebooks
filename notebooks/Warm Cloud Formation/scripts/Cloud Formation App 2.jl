using PyCall, Gadfly, Printf, Colors, SpecialFunctions

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

x = exp10.(range(log10(0.1), stop=log10(10), length = 100))
@manipulate throttle = 0.1 for w = x, Nccn = 500:100:5000
      Gadfly.set_default_plot_size(22Gadfly.cm, 12Gadfly.cm)

      xtlabel = -1:0.5:1.5
      ytlabel = -20:20:200
      lfunx = x->ifelse(sum(x .== xtlabel) == 1, @sprintf("%.1f", x), "")
      lfuny = x->ifelse(sum(x .== ytlabel) == 1, @sprintf("%i", x), "")
      zarr = 0.0:1:200.0
      z,T,wc,S = pmodel(Nccn, w)
      smax = maximum(S)
      zmax = z[S .== smax]
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

      smax00 = round(smax,digits=3)
      zmax00 = round(zmax[end].-zLCL,digits = 0)
      str = @sprintf("zmax = %i m", zmax[end]-zLCL)
      push!(layers, layer(x = [smax, smax], y = [-100,zmax[end]-zLCL], Geom.line, Geom.point,
            Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
            color = ["smax = $smax00 %" for i = 1:2]))
      push!(layers, layer(x = [-100, smax], y = [zmax00,zmax00], Geom.line, Geom.point,
            color = [str for i = 1:2]))

      guides = []
      push!(guides, Guide.xlabel("Supersaturation (%)"))
      push!(guides, Guide.ylabel("Height above LCL (m)"))
      push!(guides, Guide.title("Supersaturation Profile"))
      push!(guides, Guide.xticks(ticks=-1:0.1:2))
      push!(guides, Guide.yticks(ticks=-20:10:200))

      scales = []
      push!(scales, Scale.x_continuous(labels = lfunx))
      push!(scales, Scale.y_continuous(labels = lfuny))
      push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3", "purple"))

      coords = []    
      push!(coords,Coord.cartesian(xmin=-1, xmax=1.5, ymin = -20, ymax = 100.0))

      p1 = plot(layers..., guides...,scales...,coords...)

      κ = 0.6
      Dg = 0.05e-6
      A = 2.1e-9
      σ = 2.0
      ψ(s) = (4/27)^(1/3)*A/(κ^(1/3)*Dg*log(s/100+1)^(2/3))
      Af(s) = 1/2*erfc(log.(ψ.(s))/(sqrt(2)*log(σ)))
      Z = z .- zLCL
      
      layers = []
      ii = (Z.<=(zmax[end]-zLCL)) .& (Z.>=0.0)
      jj = (Z.>=(zmax[end]-zLCL))
      y = [Z[ii];Z[jj]]
      x = [Nccn.*Af.(S[ii]); [Nccn.*Af.(smax) for i = 1:sum(jj)]]
      CDNC = Nccn.*Af.(smax)
      push!(layers, layer(x = x, y = y, Geom.line, 
                        color = ["CDNC(z)" for i = 1:length(x)]))

      str1 = @sprintf("CDNC = %i cm<sup>-3</sup>", CDNC)
      push!(layers, layer(x = [CDNC, CDNC], y = [-100,zmax[end]-zLCL], Geom.line, Geom.point,
            Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
                 color = [str1 for i = 1:2]))
      push!(layers, layer(x = [-1000, CDNC], y = [zmax00,zmax00], Geom.line, Geom.point,
                  color = [str for i = 1:2]))
            

      guides = []
      push!(guides, Guide.xlabel("CDNC (cm-3)"))
      push!(guides, Guide.ylabel("Height above LCL (m)"))
      push!(guides, Guide.title("Cloud Droplet Number Concentration Profile"))
      push!(guides, Guide.xticks(ticks=0:1000:5000))
      push!(guides, Guide.yticks(ticks=-20:10:100))

      scales = []
      # push!(scales, Scale.x_continuous(labels = lfunx))
      # push!(scales, Scale.y_continuous(labels = lfuny))
      push!(scales, Scale.color_discrete_manual("black", "steelblue3", "purple"))

      coords = []    
       push!(coords,Coord.cartesian(xmin=0, xmax=5000, ymin = -20, ymax = 100.0))

      p2 = plot(layers..., guides...,scales...,coords...)

      hstack(p1,p2)
end