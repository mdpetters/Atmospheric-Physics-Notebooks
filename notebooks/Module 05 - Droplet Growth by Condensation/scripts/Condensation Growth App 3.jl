using PyCall, Gadfly, Printf, Colors, SpecialFunctions,Distributions,AtmosphericThermodynamics

function pmodel(N,V)
      pm = pyimport("pyrcel")

      T0 = 280.0
      S0 = -0.02
      P0 = 80000.0
      accom=1.0
      

      dist = pm.Lognorm(mu=0.05, sigma=2.0, N=N)
      aer =  pm.AerosolSpecies("sulfate", dist, kappa=0.6, bins=100)
      model = pm.ParcelModel([aer,], V, T0, S0, P0, accom=accom, console=false)
      parcel_trace, aer_out = model.run(t_end=1200.0/V, output_dt=1.0/V, solver="cvode", output="dataframes", terminate=false)
      z  = parcel_trace.z.values
      p = parcel_trace.P.values
      Tx  = parcel_trace.T.values'
      T  = Tx[:,3]
      wc = parcel_trace.wc.values.*1000.0
      S  = parcel_trace.S.values.*100.0
      z,T,p,wc,S,aer,aer_out
end



Nccn = 500.0
w = 3.0

p0 = 1000.0
T = 280.0
alpha1 = 100.0*( 0.622 * Lv * g / (Rd * T^2.0 * AtmosphericThermodynamics.cp) - g/(Rd*T))      

xtlabel = -1:0.5:1.0
ytlabel = 0:100:1000
lfunx = x->ifelse(sum(x .== xtlabel) == 1, @sprintf("%.1f", x), "")
lfuny = x->ifelse(sum(x .== ytlabel) == 1, @sprintf("%i", x), "")
zarr = 0.0:1:200.0
z,T,p,wc,S,aer,aer_out  = pmodel(Nccn, w)
rhoa = p./(Rd.*T)
wc = wc.*rhoa
smax = maximum(S)
zmax = z[S .== smax]
zLCL = (z[S .> 0.0])[1]
N = aer.Nis*1e-5
Nmax,ii = findmax(N)
Dp = aer_out["sulfate"].values.*2.0


@manipulate for height_above_LCL = 0:10:1000
    Gadfly.set_default_plot_size(29Gadfly.cm, 18Gadfly.cm)
    layers = []
    push!(layers, layer(x =-2.0 .+ alpha1.*zarr, y = zarr .- zLCL, Geom.line, Theme(line_style=[:dash]),
            color = ["S = α₁*z" for i = 1:length(zarr)]))
    push!(layers, layer(x = S, y = z .- zLCL, Geom.line(preserve_order=true), 
          color = ["S(z)" for i = 1:length(S)]))
    push!(layers, layer(x = [-1,2], y = [0,0], Geom.line,   color = ["LCL" for i = 1:2]))
    push!(layers, layer(x = [0,0], y = [-30,1210], Geom.line, color = ["LCL" for i = 1:2]))

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
    push!(guides, Guide.yticks(ticks=0:100:1000))

    scales = []
    push!(scales, Scale.x_continuous(labels = lfunx))
    push!(scales, Scale.y_continuous(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3", "purple"))

    coords = []    
    push!(coords,Coord.cartesian(xmin=-1, xmax=1.0, ymin = -20, ymax = 1000.0))

    p1 = plot(layers..., guides...,scales...,coords...)

    layers = []
    push!(layers, layer(x = wc, y = z .- zLCL, Geom.line, 
                    color = ["LWC g/kg" for i = 1:length(z)]))
        

    guides = []
    push!(guides, Guide.xlabel("LWC (g water/m3 air)"))
    push!(guides, Guide.ylabel("Height above LCL (m)"))
    push!(guides, Guide.title("Liquid water profile"))
    push!(guides, Guide.xticks(ticks=0:0.5:2))
    push!(guides, Guide.yticks(ticks=0:100:1000))

    scales = []
    push!(scales, Scale.color_discrete_manual("black", "steelblue3", "purple"))

    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=2.0, ymin = -20, ymax = 1000.0))

    p2 = plot(layers..., guides...,scales...,coords...)

    colors = ["black", "darkred", "steelblue3"]

    p3 = plot(layer(x = Dp[:,ii].*1e6, y = z, color = ["Mode diameter" for i = 1:length(z)], Geom.step), 
        Guide.xlabel("Mode diameter (μm)"),
        Guide.ylabel("Height above LCL (m)"),
        Guide.title("Mode diameter profile"),
        Guide.xticks(ticks = 0:2:20),
        Scale.color_discrete_manual(colors...),
        Coord.cartesian(xmin=0, xmax=20, ymin = -20, ymax = 1000.0))



    #---------------------------------------------------------------------------------------------------


    xticks = log10.(collect([0.01:0.01:0.09;0.1:0.1:0.9;1:1:9;10:10:40]))
    xlabel = log10.([0.01, 0.1,1,10])
    jj = height_above_LCL+43
    z[jj]
    str = @sprintf("DSD at %03i m above LCL", z[jj].-zLCL)
    l1 = ["Below cloud aerosol distribution" for i=1:length(N)]
    l2 = [str for i=1:length(N)]
    str1 = @sprintf("Mode diameter %.1f (μm)", Dp[jj,ii].*1e6)
    l3 = [str1 for i=1:2]

    p4 = plot(layer(x = Dp[1,:].*1e6, y = N, color = l1, Geom.step), 
        layer(x = Dp[jj,:].*1e6, y = N, color = l2, Geom.step),
        layer(x = [Dp[jj,ii], Dp[jj,ii]].*1e6, y = [0,Nmax], color = l3, Geom.line),
        Guide.xlabel("Droplet diameter (μm)"),
        Guide.ylabel("Concentration (cm<sup>-3</sup>)"),
        Guide.xticks(ticks = xticks),
        Scale.x_log10(labels = x->ifelse(sum(x.==xlabel)==1,@sprintf("%.2f", exp10(x)), "")), 
        Scale.color_discrete_manual(colors...),
        Coord.cartesian(xmin=-2, xmax=log10(40)))


    s1 = hstack(p1,p2, p3)
    vstack(s1,p4)
end