using Gadfly, Interact, Colors
using SpecialFunctions, Printf

s = 0.008:0.01:2
w0 = 0.1:0.1:20


@manipulate for C = 50:50:2000, k = 0.2:0.05:1.0, w = [0.1:0.1:0.9;1:1:20]
    Gadfly.set_default_plot_size(23Gadfly.cm, 9Gadfly.cm)
    wx = w*100.0
    BETA = beta(k/2.0,1.5)
    Nccn = @. C*s^k
    Nd0 = @. C^(2/(k+2)) * ( (1.6e-3*wx^1.5) / (k*BETA) ) ^ (k/(k+2.0))
    Nd = @. C^(2/(k+2)) * ( (1.6e-3*(w0.*100.0)^1.5) / (k*BETA) ) ^ (k/(k+2.0))
    smax = (1.6e-3*wx^1.5 / (C*k*BETA)) ^ (1/(k+2)) 

   
    xticks = log10.([collect(0.01:0.01:0.09);collect(0.1:0.1:1)])
    xtlabel = [0.01, 0.1, 1]
    ytlabel = [10, 100, 1000]
    yticks = log10.([1:1:10;20:10:100;200:100:1000])

    lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("%.2f", exp10(x)), "")
    lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

    layers = []
    push!(layers, layer(x = s, y = Nccn, Geom.line,
          color = ["N<sup>CCN</sup> = Cs<sup>k</sup>" for i = 1:length(s)]))
    smax00 = round(smax,digits = 2)
    push!(layers, layer(x = [smax, smax], y = [3.0,Nd0], Geom.line, Geom.point,
         Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
         color = ["smax = $smax00 %" for i = 1:2]))
    Nd00 = round(Nd0,digits = 1)
    push!(layers, layer(x = [0.001, smax], y = [Nd0,Nd0], Geom.line, Geom.point,
          color = ["CDNC = $Nd00 cm<sup>-3<sup>" for i = 1:2]))

    guides = []
    push!(guides, Guide.xlabel("Supersaturation (%)"))
    push!(guides, Guide.ylabel("CCN Concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.title("CDNC from CCN spectrum and smax"))
    push!(guides, Guide.xticks(ticks=xticks))
    push!(guides, Guide.yticks(ticks=yticks))

    scales = []
    push!(scales, Scale.x_log10(labels = lfunx))
    push!(scales, Scale.y_log10(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))
    
    coords = []    
    push!(coords,Coord.cartesian(xmin=log10(0.008), xmax=log10(2.0), ymin = log10(8), ymax = log10(3000)))

    p1 = plot(layers..., guides...,scales...,coords...)


##-----------------------------------------------------------------------------

xticks = log10.([collect(0.1:0.1:0.9);collect(1:1:10);20])
xtlabel1 = [0.1, 1, 10]
ytlabel = [10, 100, 1000]
yticks = log10.([1:1:10;20:10:100;200:100:1000])

lfunx1 = x->ifelse(sum(exp10.(x) .== xtlabel1) == 1, @sprintf("%.2f", exp10(x)), "")
lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

layers = []
push!(layers, layer(x = w0, y = Nd, Geom.line,
      color = ["CDNC = f(C,k,w)" for i = 1:length(w0)]))

 push!(layers, layer(x = [w, w], y = [1, Nd0], Geom.line, Geom.point,
 Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
      color = ["w0 = $w m s<sup>-1</sup>" for i = 1:2]))

push!(layers, layer(x = [0.001, w], y = [Nd0, Nd0], Geom.line, Geom.point,
     color = ["CDNC = $Nd00 cm<sup>-3<sup>" for i = 1:2]))


guides = []
push!(guides, Guide.xlabel("Updraft velocity (m/s)"))
push!(guides, Guide.ylabel("CDNC (cm<sup>-3</sup>)"))
push!(guides, Guide.title("CDNC from Twomey Equation"))
push!(guides, Guide.xticks(ticks=xticks))
push!(guides, Guide.yticks(ticks=yticks))

scales = []
push!(scales, Scale.x_log10(labels = lfunx1))
push!(scales, Scale.y_log10(labels = lfuny))
push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

coords = []    
push!(coords,Coord.cartesian(xmin=log10(0.08), xmax=log10(20.0), ymin = log10(8), ymax = log10(3000)))

p2 = plot(layers..., guides...,scales...,coords...)


    hstack(p1,p2)
end
