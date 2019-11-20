
using Gadfly

Gadfly.set_default_plot_size(14Gadfly.cm, 10Gadfly.cm)

s = [0.1, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2]
N = @. 800.0*s^0.7

layers = []
push!(layers, layer(x=s, y = N, Geom.line, Geom.point, Theme(default_color = "black")))

guides = []
push!(guides, Guide.xlabel("Supersaturation (%)"))
push!(guides, Guide.ylabel("Cumulative CCN Concentration (cm<sup>-3</sup>)"))
push!(guides, Guide.title("Example CCN Data"))
push!(guides, Guide.xticks(ticks=[0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2]))
push!(guides, Guide.yticks(ticks=[0,200,400,600,800,1000]))

scales = []
coords = []    
push!(coords,Coord.cartesian(xmin=0.05, xmax=1.3, ymin = 0, ymax = 1000))

p1 = plot(layers..., guides..., scales..., coords...)   