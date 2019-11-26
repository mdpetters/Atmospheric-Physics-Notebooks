using DifferentialMobilityAnalyzers, DataFrames, Gadfly, Interact, Colors

Gadfly.set_default_plot_size(10Gadfly.cm, 8Gadfly.cm)
colors = ["black", "darkred", "steelblue3"]

𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10); 

p = plot(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.N, Geom.bar, 
         Theme(default_color="steelblue3"),
         Guide.xlabel("Particle diameter (nm)"),
         Guide.ylabel("Number concentration (cm <sup>-3</sup>)"),
         Guide.title("Histogram Representation of Table Above"),
         Guide.xticks(ticks = 0:50:300),
         Scale.color_discrete_manual(colors...),
         Coord.cartesian(xmin=0, xmax=300, ymax = 100)) 