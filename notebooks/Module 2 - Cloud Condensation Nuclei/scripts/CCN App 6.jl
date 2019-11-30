using Printf, Colors, Gadfly, Interpolations, DataFrames, CSV

A = 2.1e-9
S(D,Dd,κ) = (D^3.0 - Dd^3.0)/(D^3.0 - Dd^3.0*(1.0-κ))*exp(A/D)
sc(Dd,κ) = (maximum(S.(collect(range.(Dd*1.01,stop=60.0*Dd,length=500)),Dd,κ))-1.0)*100.0
gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function ccn_app6(κ)
    Gadfly.set_default_plot_size(15Gadfly.cm, 8Gadfly.cm)
    colors = ["black", "steelblue3", "darkred", "darkgreen" ]
    
    # Amazon Gunthe 
    tDd = [54, 83, 105, 129, 198.0]
    tsc = [0.82, 0.46, 0.28, 0.19, 0.10]
    df1 = DataFrame(Dd = tDd, sc = tsc, 
                    composition = ["Pristine Amazon Rainforest" for i = 1:length(tDd)],
                    airmass = ["Continental" for i = 1:length(tDd)])


    df2 = CSV.read("figures/Hudson RICO.txt")
    df2[!,:composition] = ["Western Atlantic" for i = 1:length(df2[!,:sc])]
    df2[!,:airmass] = ["Marine" for i = 1:length(df2[!,:sc])]

    df3 = CSV.read("figures/Hudson AIRS2.txt")
    df3[!,:composition] = ["Syracuse, NY" for i = 1:length(df3[!,:sc])]
    df3[!,:airmass] = ["Continental" for i = 1:length(df3[!,:sc])]

    df4 = CSV.read("figures/Hudson MASE.txt")
    df4[!,:composition] = ["Eastern Pacific" for i = 1:length(df4[!,:sc])]
    df4[!,:airmass] = ["Coastal" for i = 1:length(df4[!,:sc])]


    df = [df2;df4;df1;df3]

    Dd = exp10.(range(log10(10e-9), stop=log10(3e-6),length=100))
    msc = sc.(Dd,κ)

    label = [@sprintf("κ=%.2f",κ) for i=1:length(Dd)]
    layers = []
    push!(layers,layer(x = Dd*1e9, y = msc, color = label, Geom.line))

    push!(layers,layer(x = df[!,:Dd], y = df[!,:sc], color = df[!,:airmass], shape = df[!,:composition], Geom.point,
             Theme(alphas=[0.3], discrete_highlight_color=cfun, point_size=3Gadfly.pt)))

    guides = []

    push!(guides, Guide.xlabel("Dry diameter (nm)"))
    push!(guides, Guide.ylabel("Supersaturation (%)"))
    push!(guides, Guide.title("Köhler Theory"))
    push!(guides, Guide.xticks(ticks=log10.([10:10:90;100:100:1000])))
    push!(guides, Guide.yticks(ticks=log10.([0.08;0.09;0.1:0.1:1;2])))


    xtlabel = log10.([10,100])
    ytlabel = log10.([0.1,1])
    lfunx = x->ifelse(sum(x .== xtlabel) == 1, @sprintf("%i", exp10(x)), "")
    lfuny = x->ifelse(sum(x .== ytlabel) == 1, @sprintf("%.1f", exp10(x)), "")

    scales = []
    push!(scales, Scale.x_log10(labels=lfunx))
    push!(scales, Scale.y_log10(labels=lfuny))
    push!(scales, Scale.color_discrete_manual(colors...))

    coords = []    
    push!(coords,Coord.cartesian(xmin=log10(10), xmax=log10(300), ymin = log10(0.08), ymax =log10(2)))

    p0 = plot(layers..., guides..., scales..., coords..., Theme(key_swatch_color="slategrey"))
end

κs = [0;0.01:0.01:1;1.1;1.2;1.3]
κ6 = slider(κs; value = 0.4, label = "Hygroscopicity (-)", throttle=1.0)
display(κ6)
p = map(ccn_app6, κ6)