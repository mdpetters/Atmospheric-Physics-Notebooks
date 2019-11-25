using CSV, Gadfly, Printf, Interact
                        
df1 = CSV.read("figures/Ramanathan North Sea Maritime.txt")
df1[!,:Region] = ["North Sea (Marine)" for i = 1:length(df1[!,:Na])]
df1[!,:Regime] = ["Marine" for i = 1:length(df1[!,:Na])]

df2 = CSV.read("figures/Ramanathan North Sea Continental.txt")
df2[!,:Region] = ["North Sea (Continental)" for i = 1:length(df2[!,:Na])]
df2[!,:Regime] = ["Continental" for i = 1:length(df2[!,:Na])]

df3 = CSV.read("figures/Ramanathan Nova Scotia 1.txt")
df3[!,:Region] = ["North Atlantic" for i = 1:length(df3[!,:Na])]
df3[!,:Regime] = ["Marine" for i = 1:length(df3[!,:Na])]

df4 = CSV.read("figures/Ramanathan Nova Scotia 2.txt")
df4[!,:Region] = ["North Atlantic" for i = 1:length(df4[!,:Na])]
df4[!,:Regime] = ["Marine" for i = 1:length(df4[!,:Na])]

df5 = CSV.read("figures/Ramanathan Arabian Sea.txt")
df5[!,:Region] = ["Arabian Sea" for i = 1:length(df5[!,:Na])]
df5[!,:Regime] = ["Continental" for i = 1:length(df5[!,:Na])]

df = [df1;df2;df3;df4;df5]

@manipulate for a = 0:0.1:10, β = 0.3:0.01:1 
    Gadfly.set_default_plot_size(16Gadfly.cm, 10Gadfly.cm)
    Na = 0:10:2500
    CDNC = @. a*Na^β

    xticks = log10.([50:10:90;100.0:100:1000;2000])
    xtlabel = [100, 1000]
    ytlabel = [10, 100, 1000]
    yticks = log10.([1:1:10;20:10:100;200:100:1000])

    lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("%i", exp10(x)), "")
    lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

    layers = []
    push!(layers, layer(x=df[!,:Na], y = df[!,:CDNC], color = df[!,:Region], Geom.line), Theme(line_width=1Gadfly.pt))
    push!(layers, layer(x=Na, y = CDNC, color = ["CDNC = a*Na<sup>β</sup>" for i = 1:length(Na)], Geom.line), Theme(line_width=2Gadfly.pt))

    guides = []
    push!(guides, Guide.xlabel("Aerosol number concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.ylabel("Cloud droplet number concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.xticks(ticks=xticks))
    push!(guides, Guide.yticks(ticks=yticks)) 

    scales = []
    push!(scales, Scale.x_log10(labels = lfunx))
    push!(scales, Scale.y_log10(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3", "grey"))

    coords = []
    push!(coords,Coord.cartesian(xmin=log10(50), xmax=log10(3000), ymin = log10(50), ymax = log10(1000)))

    p1 = plot(layers..., guides..., scales..., coords...)
end