using DifferentialMobilityAnalyzers, DataFrames, Gadfly, Interact, Colors

function aerosol_figure3()
    Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)
    colors = ["black", "darkred", "steelblue3"]

    𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10); 

    p1 = plot(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S, Geom.bar, 
            Theme(default_color="steelblue3"),
            Guide.xlabel("Particle diameter (nm)"),
            Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
            Guide.title("Spectral Density Representation 10 Bins"),
            Guide.xticks(ticks = 0:50:300),
            Scale.color_discrete_manual(colors...),
            Coord.cartesian(xmin=0, xmax=300)) 

    𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 40); 

    p2 = plot(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S, Geom.bar, 
            Theme(default_color="steelblue3"),
            Guide.xlabel("Particle diameter (nm)"),
            Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
            Guide.title("Spectral Density Representation 40 Bins"),
            Guide.xticks(ticks = 0:50:300),
            Scale.color_discrete_manual(colors...),
            Coord.cartesian(xmin=0, xmax=300)) 

    hstack(p1,p2)
end

aerosol_figure3()