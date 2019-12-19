using Gadfly, Printf, DataFrames, Dates, CSV, Colors, LsqFit, Interact

df1 = CSV.read("figures/Hohenpeissenberg.txt")
df1[!,:Region] = ["Hohenpeissenberg" for i = 1:length(df1[!,:g])]

df2 = CSV.read("figures/Macquarie Island.txt")
df2[!,:Region] = ["Macquarie Island" for i = 1:length(df2[!,:g])]

df3 = CSV.read("figures/ANARChe.txt")
df3[!,:Region] = ["Atlanta, Georgia" for i = 1:length(df3[!,:g])]

df4 = CSV.read("figures/Theory dry AS.txt")
df4[!,:Region] = ["Theory dry ammonium sulfate" for i = 1:length(df4[!,:g])]


df = [df2;df1;df3]
colors = ["darkred", "darkgoldenrod3", "steelblue3", "black"]
gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]

Gadfly.set_default_plot_size(20Gadfly.cm, 10Gadfly.cm)

layers = []
push!(layers, layer(x=df[!,:c], y = df[!,:g], color = df[!,:Region], Geom.point))
push!(layers, layer(x=df4[!,:c], y = df4[!,:g], color = df4[!,:Region], Geom.line))

xticks = log10.(gengrid([100000,1000000,10000000,100000000,1000000000]))
xtlabel = [1e5, 1e6, 1e7, 1e8, 1e9,1e10]
ytlabel = [0.1, 1, 10, 100]
yticks = log10.(gengrid([0.1,1,10]))

lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("10<sup>%i</sup>", x), "")
lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%.1f", exp10(x)), "")

guides = []
push!(guides, Guide.xlabel("H<sub>2</sub>SO<sub>4</sub> concentration (cm<sup>-3</sup>)"))
push!(guides, Guide.ylabel("Modal growth rate (nm hr<sup>-1</sup>)"))
push!(guides, Guide.title("Observed Modal Growth Rates"))
push!(guides, Guide.xticks(ticks=xticks))
push!(guides, Guide.yticks(ticks=yticks))

scales = []
push!(scales, Scale.x_log10(labels = lfunx))
push!(scales, Scale.y_log10(labels = lfuny))
push!(scales, Scale.color_discrete_manual(colors...))

coords = []
push!(coords,Coord.cartesian(xmin=log10(1e5), xmax=log10(1e10), ymin = log10(1e-1), ymax = log10(1e2)))

p1 = plot(layers..., guides..., scales..., coords..., 
    Theme(highlight_width=0.4Gadfly.pt, key_swatch_color=colorant"slategrey"))
