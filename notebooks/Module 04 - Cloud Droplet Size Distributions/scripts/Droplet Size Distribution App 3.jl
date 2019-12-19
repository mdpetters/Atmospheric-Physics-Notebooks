using Distributions, Interact, Gadfly, Colors, Printf, CSV

function dsd_app3(Dn,Nt,v)
    Gadfly.set_default_plot_size(18Gadfly.cm, 11Gadfly.cm)
    df1 = CSV.read("figures/Biomass Smoke Cloud.txt")
    df1[!,:Regime] = ["Biomass Smoke Cloud" for i = 1:length(df1[!,:D])]
    df1[!,:N] = df1[!,:N]./3.0


    df2 = CSV.read("figures/Indian Ocean Cloud.txt")
    df2[!,:Regime] = ["Indian Ocean Cloud" for i = 1:length(df2[!,:D])]
    df2[!,:N] = df2[!,:N]./3.0

    df3 = CSV.read("figures/Industrial Polluted Cloud.txt")
    df3[!,:Regime] = ["Industrial Polluted Cloud" for i = 1:length(df3[!,:D])]
    df3[!,:N] = df3[!,:N]./3.0

    xlabel = log10.([1,10,100])
    x = log10.(collect([1:1:9;10:10:90;100]))
    colors = "black", "darkred", "steelblue3", "purple"
    df = [df1;df3;df2]

    De = exp10.(range(log10(0.1e-6), stop=log10(500e-6),length=200))
    Dp = sqrt.(De[2:end].*De[1:end-1])
    ΔD = (De[2:end]-De[1:end-1])
    S = Nt*pdf.(Gamma(v,Dn),Dp).*1e-6

    plot(layer(x = df[!,:D],y=df[!,:N],color=df[!,:Regime], Geom.line),
         layer(x = Dp*1e6,y=S,color = ["Gamma PDF" for i =1:length(S)], Geom.step),
         Guide.ylabel("Droplet Concentration Density (cm<sup>-3</sup> μm<sup>-3</sup>)"),
         Guide.xlabel("Droplet diameter (μm)"), 
         Guide.xticks(ticks = x),
         Scale.x_log10(labels = x->ifelse(sum(x.==xlabel)==1,@sprintf("%i", exp10(x)), "")), 
         Scale.color_discrete_manual(colors...),
         Coord.cartesian(xmin=log10(1), xmax=log10(100), ymin = 0, ymax = 150))
end

Dn = slider(collect(0.1:0.1:10), value = 1.1, label = "Dn (μm)")
Nt = slider(collect([10:10:90;100:20:2000]), value = 1100, label = "Nt (cm-3)")
v = slider(1:0.1:20, value = 10.0, label = "v (-)")
display(map((i,j,k)->dsd_app3(i*1e-6,j,k), observe(Dn), observe(Nt), observe(v)))
b1 = hbox(pad(0.5em, Nt), pad(0.5em, Dn))
display(hbox(b1, pad(0.5em,v)))


