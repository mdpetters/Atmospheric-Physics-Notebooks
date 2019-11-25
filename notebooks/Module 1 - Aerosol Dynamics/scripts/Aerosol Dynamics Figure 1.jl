using DifferentialMobilityAnalyzers, DataFrames, Gadfly, Interact

Gadfly.set_default_plot_size(14Gadfly.cm, 9Gadfly.cm)
colors = ["black", "darkred", "steelblue3"]

𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10); 

p = plot(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.N, Geom.bar,
         Theme(default_color="darkred"),
         Guide.xlabel("Particle diameter (nm)"),
         Guide.ylabel("Number concentration (cm <sup>-3</sup>)"),
         Guide.title("Histogram Representation of Table Above"),
         Guide.xticks(ticks = 0:50:300),
         Scale.color_discrete_manual(colors...),
         Coord.cartesian(xmin=0, xmax=300)) 


# p = plot([0.1,0.1], [0,0], legend = :none, right_margin = 100px)
# map(1:10) do i
#     p = plot!([𝕟.De[i], 𝕟.De[i+1]], [𝕟.N[i], 𝕟.N[i]], color = :black)
#     p = plot!([𝕟.De[i], 𝕟.De[i]], [0, 𝕟.N[i]], color = :black)
#     p = plot!([𝕟.De[i+1], 𝕟.De[i+1]], [0, 𝕟.N[i]], color = :black)
# end

# m = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 500); 
# plot(p, xscale = :lin, xlim = (30,300), ylim = (0,100), xlabel = "Particle Diameter (nm)", 
#     ylabel = "N (cm<sup>-3</sup>)")