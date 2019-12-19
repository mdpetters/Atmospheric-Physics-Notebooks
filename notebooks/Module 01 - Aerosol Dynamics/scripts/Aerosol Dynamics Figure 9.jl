using DifferentialMobilityAnalyzers, DataFrames, Gadfly, Interact, Colors, Printf

Gadfly.set_default_plot_size(20Gadfly.cm, 16Gadfly.cm)
colors = ["black", "darkred", "steelblue3"]

𝕟 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 10)
𝕗 = lognormal([[200, 80, 1.2]]; d1 = 30.0, d2 = 300.0, bins = 500); 

xlabel = log10.([30, 50, 100, 200, 300])
lfunx = x->ifelse(sum(x .== xlabel) == 1, @sprintf("%i",exp10(x)), "")

p1 = plot(layer(x=𝕗.Dp, y = 𝕗.S, Geom.line, Gadfly.style(default_color=colorant"black")),
          layer(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S, Geom.bar), 
          Theme(default_color="steelblue3"),
          Guide.xlabel("Particle diameter (nm)"),
          Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
          Guide.title("Number Spectral Density"),
          Scale.color_discrete_manual(colors...),
          Guide.xticks(ticks = log10.([30:10:100;200;300])),
          Scale.x_log10(labels = lfunx),
          Coord.cartesian(xmin=log10(30), xmax=log10(300))) 

p2 = plot(layer(x=𝕗.Dp, y = 𝕗.S.*π.*(𝕗.Dp.*1e-3).^2.0, Geom.line,
          Gadfly.style(default_color=colorant"black")),
          layer(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S.*π.*(𝕟.Dp.*1e-3).^2.0, Geom.bar), 
          Theme(default_color="steelblue3"),
          Guide.xlabel("Particle diameter (nm)"),
          Guide.ylabel("dS/dlnD (μm<sup>2</sup> cm <sup>-3</sup>)"),
          Guide.title("Surface Area Spectral Density"),
          Guide.xticks(ticks = log10.([30:10:100;200;300])),
          Scale.x_log10(labels = lfunx),
          Scale.color_discrete_manual(colors...),
          Coord.cartesian(xmin=log10(30), xmax=log10(300))) 

p3 = plot(layer(x=𝕗.Dp, y = 𝕗.S.*π.*(𝕗.Dp.*1e-3).^3.0./6.0, Geom.line,
          Gadfly.style(default_color=colorant"black")),
          layer(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S.*π.*(𝕟.Dp.*1e-3).^3.0./6.0, Geom.bar), 
          Theme(default_color="steelblue3"),
          Guide.xlabel("Particle diameter (nm)"),
          Guide.ylabel("dV/dlnD (μm<sup>3</sup> cm <sup>-3</sup>)"),
          Guide.title("Volume  Spectral Density"),
          Guide.xticks(ticks = log10.([30:10:100;200;300])),
          Scale.x_log10(labels = lfunx),
          Scale.color_discrete_manual(colors...),
          Coord.cartesian(xmin=log10(30), xmax=log10(300))) 

p4 = plot(layer(x=𝕗.Dp, y = 𝕗.S.*π.*(𝕗.Dp.*1e-3).^3.0./6.0*2.0, Geom.line,
          Gadfly.style(default_color=colorant"black")),
          layer(xmin = 𝕟.De[1:end-1], xmax = 𝕟.De[2:end], y = 𝕟.S.*π.*(𝕟.Dp.*1e-3).^3.0./6.0*2.0, Geom.bar), 
          Theme(default_color="steelblue3"),
          Guide.xlabel("Particle diameter (nm)"),
          Guide.ylabel("dM/dlnD (g m <sup>-3</sup>)"),
          Guide.title("Mass Spectral Density"),
          Guide.xticks(ticks = log10.([30:10:100;200;300])),
          Scale.x_log10(labels = lfunx),
          Scale.color_discrete_manual(colors...),
          Coord.cartesian(xmin=log10(30), xmax=log10(300))) 

vstack(hstack(p1,p2),hstack(p3,p4))