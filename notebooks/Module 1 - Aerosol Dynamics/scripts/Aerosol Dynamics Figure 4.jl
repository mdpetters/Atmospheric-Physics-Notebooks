using DifferentialMobilityAnalyzers, DataFrames, Gadfly, Interact, Colors, Printf

Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)
colors = ["black", "darkred", "steelblue3"]

𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10); 
xlabel = log10.([30, 50, 100, 200, 300])
lfunx = x->ifelse(sum(x .== xlabel) == 1, @sprintf("%i",exp10(x)), "")

p1 = plot(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S, Geom.bar, 
         Theme(default_color="steelblue3"),
         Guide.xlabel("Particle diameter (nm)"),
         Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
         Guide.title("Spectral Density Representation 10 Bins - Logscale"),
         Scale.color_discrete_manual(colors...),
         Guide.xticks(ticks = log10.([30:10:100;200;300])),
         Scale.x_log10(labels = lfunx),
         Coord.cartesian(xmin=log10(30), xmax=log10(300))) 


𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 40); 

p2 = plot(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S, Geom.bar, 
         Theme(default_color="steelblue3"),
         Guide.xlabel("Particle diameter (nm)"),
         Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
         Guide.title("Spectral Density Representation 40 Bins - Logscale"),
         Guide.xticks(ticks = log10.([30:10:100;200;300])),
         Scale.x_log10(labels = lfunx),
         Scale.color_discrete_manual(colors...),
         Coord.cartesian(xmin=log10(30), xmax=log10(300))) 

hstack(p1,p2)