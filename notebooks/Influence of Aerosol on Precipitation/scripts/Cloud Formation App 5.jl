using Gadfly, CSV

df1 = CSV.read("figures/Andreae Blue Ocean.txt")
df1[!,:Regime] = ["Blue Ocean" for i = 1:length(df1[!,:D])]
df1[!,:Sample] = ["1" for i = 1:length(df1[!,:D])]

df2 = CSV.read("figures/Andreae Green Ocean 1.txt")
df2[!,:Regime] = ["Green Ocean 1" for i = 1:length(df2[!,:D])]
df2[!,:Sample] = ["1" for i = 1:length(df2[!,:D])]

df3 = CSV.read("figures/Andreae Green Ocean 2.txt")
df3[!,:Regime] = ["Green Ocean 2" for i = 1:length(df3[!,:D])]
df3[!,:Sample] = ["2" for i = 1:length(df3[!,:D])]

df4 = CSV.read("figures/Andreae Thai.txt")
df4[!,:Regime] = ["Thailand" for i = 1:length(df3[!,:D])]
df4[!,:Sample] = ["1" for i = 1:length(df3[!,:D])]

df = [df1;df2;df3;df4]
Gadfly.set_default_plot_size(13Gadfly.cm, 11Gadfly.cm)
    layers = []
    push!(layers, layer(x = df[!,:D], y=df[!,:z]./1000, color = df[!,:Regime], Geom.line, Geom.point))
    push!(layers, layer(x = [24,24], y=[0, 10], color = ["Autoconversion Threshold" for i = 1:2], Geom.line))
    push!(layers, layer(x = [0,40], y=[0, 10], color = ["Model" for i = 1:2], Geom.line))
    
    guides = []
    push!(guides, Guide.xlabel("Modal drop diameter (µm)"))
    push!(guides, Guide.ylabel("Height above cloud base (km)"))
    push!(guides, Guide.xticks(ticks=0:5:40))
    push!(guides, Guide.yticks(ticks=0:1:8))


    scales = []
    push!(scales, Scale.color_discrete_manual("steelblue3", "mediumseagreen", "darkgreen", "darkgoldenrod3", "darkred", "black"))
    
    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=40, ymin = 0, ymax = 8))
    p1 = plot(layers..., guides...,scales...,coords...)