using Gadfly, CSV, Colors
Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)
df1 = CSV.read("figures/Yin LWC Precipitating.txt")
df1[!,:Regime] = ["Precipitating Clouds" for i = 1:length(df1[!,:z])]

df2 = CSV.read("figures/Yin LWC Nonprecipitating.txt")
df2[!,:Regime] = ["Non-precipitating Clouds" for i = 1:length(df2[!,:z])]


xlabel = log10.([1e-6,1e-5,1e-4].*1e6)
x = log10.(collect([1e-6:1e-6:9e-6;1e-5:1e-5:9e-5;1e-4].*1e6))
colors = "black", "darkred", "steelblue3"
df = [df1;df2]
colors = ["black", "darkred"]

plot(y=df[!,:mean]./1000.0, x=df[!,:z]./1000, ymin=df[!,:min]./1000.0, ymax=df[!,:max]./1000.0,
     color = df[!,:Regime], Geom.line(), Geom.ribbon,
     Guide.xlabel("Height above ground level (km)"),
     Guide.ylabel("Liquid water content (g m<sup>-3</sup>)"),
     Gadfly.style(alphas=[0.2], lowlight_color=c->RGBA{Float32}(c.r, c.g, c.b, 1)),
     Guide.xticks(ticks = 2:1:9),
     Guide.yticks(ticks = 0:0.2:1.2),
     Scale.color_discrete_manual(colors...),
     Coord.cartesian(xmin=2, xmax=9))