using Distributions, Interact, Gadfly, Colors, Printf, CSV

df1 = CSV.read("figures/Biomass Smoke Cloud.txt")
df1[!,:Regime] = ["Biomass Smoke Cloud" for i = 1:length(df1[!,:D])]

df2 = CSV.read("figures/Indian Ocean Cloud.txt")
df2[!,:Regime] = ["Indian Ocean Cloud" for i = 1:length(df2[!,:D])]

df3 = CSV.read("figures/Industrial Polluted Cloud.txt")
df3[!,:Regime] = ["Industrial Polluted Cloud" for i = 1:length(df3[!,:D])]

xlabel = log10.([1e-6,1e-5,1e-4].*1e6)
x = log10.(collect([1e-6:1e-6:9e-6;1e-5:1e-5:9e-5;1e-4].*1e6))
colors = "black", "darkred", "steelblue3"
df = [df1;df3;df2]

plot(layer(x = df[!,:D],y=df[!,:N],color=df[!,:Regime], Geom.line),
     Guide.ylabel("Droplet Concentration (cm<sup>-3</sup>)"),
     Guide.xlabel("Droplet diameter (m)"), 
     Guide.xticks(ticks = x),
     Scale.x_log10(labels = x->ifelse(sum(x.==xlabel)==1,@sprintf("%.0e", exp10(x)), "")), 
     Scale.color_discrete_manual(colors...),
     Coord.cartesian(xmin=log10(1), xmax=log10(100)))
