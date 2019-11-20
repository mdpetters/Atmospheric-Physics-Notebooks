using CSV, Gadfly, Printf, Interact

df1 = CSV.read("figures/CCN Data Hudson P.txt")
df1[!,:Region] = ["Eastern Pacific" for i = 1:length(df1[!,:sc])]
df1[!,:Regime] = ["Marine" for i = 1:length(df1[!,:sc])]

df2 = CSV.read("figures/CCN Data Hudson Am.txt")
df2[!,:Region] = ["Eastern Atlantic" for i = 1:length(df2[!,:sc])]
df2[!,:Regime] = ["Marine" for i = 1:length(df2[!,:sc])]

df3 = CSV.read("figures/CCN Data Hudson Ac.txt")
df3[!,:Region] = ["Eastern Atlantic" for i = 1:length(df3[!,:sc])]
df3[!,:Regime] = ["Continental" for i = 1:length(df3[!,:sc])]

df4 = CSV.read("figures/CCN Data Hudson SO.txt")
df4[!,:Region] = ["Southern Ocean" for i = 1:length(df4[!,:sc])]
df4[!,:Regime] = ["Marine" for i = 1:length(df4[!,:sc])]

df5 = CSV.read("figures/CCN Data Hudson Sm.txt")
df5[!,:Region] = ["Florida" for i = 1:length(df5[!,:sc])]
df5[!,:Regime] = ["Coastal" for i = 1:length(df5[!,:sc])]

df6 = CSV.read("figures/CCN Data Hudson Sc.txt")
df6[!,:Region] = ["Florida" for i = 1:length(df6[!,:sc])]
df6[!,:Regime] = ["Continental" for i = 1:length(df6[!,:sc])]

df = [df1;df2;df3;df4;df5;df6]

@manipulate for C = 50:10:2000, k = 0.1:0.02:1 
    Gadfly.set_default_plot_size(13Gadfly.cm, 11Gadfly.cm)
    s = exp10.(range(log10(0.001), stop = log10(2), length = 100))
    N = @. C*s^k
    
    layers = []
    push!(layers, layer(x=df[!,:sc], y = df[!,:N], shape=df[!,:Region], color = df[!,:Regime], Geom.point))
    push!(layers, layer(x=s, y = N, Geom.line, Theme(default_color="steelblue3", line_width=2Gadfly.pt)))

    xticks = log10.([collect(0.01:0.01:0.09);collect(0.1:0.1:1)])
    xtlabel = [0.01, 0.1, 1]
    ytlabel = [1, 10, 100, 1000]
    yticks = log10.([1:1:10;20:10:100;200:100:1000])

    lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("%.2f", exp10(x)), "")
    lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

    guides = []
    push!(guides, Guide.xlabel("Supersaturation (%)"))
    push!(guides, Guide.ylabel("Number concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.title("Continental vs. Marine CCN"))
    push!(guides, Guide.xticks(ticks=xticks))
    push!(guides, Guide.yticks(ticks=yticks))
    push!(guides, Guide.shapekey(title = "Region",  pos=[2Gadfly.mm, 29Gadfly.mm]))
    push!(guides, Guide.colorkey(title = "Airmass",  pos=[32Gadfly.mm, 27Gadfly.mm]))

    scales = []
    push!(scales, Scale.x_log10(labels = lfunx))
    push!(scales, Scale.y_log10(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

    coords = []
    push!(coords,Coord.cartesian(xmin=log10(0.01), xmax=log10(1), ymin = log10(1), ymax = log10(2000)))

    p1 = plot(layers..., guides..., scales..., coords..., 
    Theme(highlight_width=0.4Gadfly.pt, key_swatch_color=colorant"slategrey"))
end