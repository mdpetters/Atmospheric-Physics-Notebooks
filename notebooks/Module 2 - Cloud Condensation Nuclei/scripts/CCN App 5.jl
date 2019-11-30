using Printf, Colors, Gadfly, Interpolations, DataFrames

A = 2.1e-9
S(D,Dd,κ) = (D^3.0 - Dd^3.0)/(D^3.0 - Dd^3.0*(1.0-κ))*exp(A/D)
sc(Dd,κ) = (maximum(S.(collect(range.(Dd*1.01,stop=60.0*Dd,length=500)),Dd,κ))-1.0)*100.0
gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function ccn_app4(κ)
    Gadfly.set_default_plot_size(15Gadfly.cm, 8Gadfly.cm)
    colors = ["black", "steelblue3", "darkred" ]
    
    # Sea-salt Nguyen et al. 
    tDd = [29.9, 50.2, 70.5, 90.9]
    tsc = [0.74, 0.36, 0.21, 0.14]
    df1 = DataFrame(Dd = tDd, sc = tsc, composition = ["Sea-salt aerosol" for i = 1:length(tDd)])

    # a-pinene Prenni
    tDd = [0.081, 0.102, 0.223, 0.130, 0.09, 0.075, 0.064, 0.056, 0.089].*1000.0
    tsc = [0.529, 0.355, 0.125, 0.249, 0.447, 0.604, 0.752, 0.919, 0.447]
    df2 = DataFrame(Dd = tDd, sc = tsc, composition = ["Secondary organic aerosol" for i = 1:length(tDd)])

    # soot Lammel
    tDd = [0.18, 0.121].*1000.0.*2
    tsc = [0.5, 1]
    df3 = DataFrame(Dd = tDd, sc = tsc, composition = ["Black carbon aerosol" for i = 1:length(tDd)])

    # ATD Koeh;er
    data = [85.9875, 0.999, 77.9966, 0.8996, 111.5319, 0.7963, 94.6867, 0.7008, 108.0346, 0.5963,
    135.3202, 0.4944, 121.7601, 0.3997, 140.5102, 0.2993]
    df4 = DataFrame(Dd = data[1:2:end-1], sc = data[2:2:end], 
            composition = ["Arizona Test Dust" for i = 1:length(data)/2])

    # AS
    tDd = [30.5, 42.5, 52.3, 71.8, 144]
    tsc = [1.02, 0.6, 0.43, 0.26, 0.09] 
    df5 = DataFrame(Dd = tDd, sc = tsc, composition = ["Ammonium sulfate" for i = 1:length(tDd)])

    df = [df1;df5;df2;df3;df4]

    Dd = exp10.(range(log10(10e-9), stop=log10(3e-6),length=100))
    msc = sc.(Dd,κ)

    label = [@sprintf("κ=%.4f",κ) for i=1:length(Dd)]
    layers = []
    push!(layers,layer(x = Dd*1e9, y=sc.(Dd,0), color = ["κ=0" for i=1:length(Dd)], Geom.line))
    push!(layers,layer(x = Dd*1e9, y=sc.(Dd,1.3), color = ["κ=1.3" for i=1:length(Dd)], Geom.line))
    push!(layers,layer(x = Dd*1e9, y = msc, color = label, Geom.line))

    push!(layers,layer(x = df[!,:Dd], y = df[!,:sc], shape = df[!,:composition], Geom.point,
             Theme(default_color="slategrey",point_size=4Gadfly.pt)))

    guides = []

    push!(guides, Guide.xlabel("Dry diameter (nm)"))
    push!(guides, Guide.ylabel("Supersaturation (%)"))
    push!(guides, Guide.title("Köhler Theory"))
    push!(guides, Guide.xticks(ticks=log10.([10:10:90;100:100:1000])))
    push!(guides, Guide.yticks(ticks=log10.([0.08;0.09;0.1:0.1:1;2])))


    xtlabel = log10.([10,100,1000])
    ytlabel = log10.([0.1,1])
    lfunx = x->ifelse(sum(x .== xtlabel) == 1, @sprintf("%i", exp10(x)), "")
    lfuny = x->ifelse(sum(x .== ytlabel) == 1, @sprintf("%.1f", exp10(x)), "")

    scales = []
    push!(scales, Scale.x_log10(labels=lfunx))
    push!(scales, Scale.y_log10(labels=lfuny))
    push!(scales, Scale.color_discrete_manual(colors...))

    coords = []    
    push!(coords,Coord.cartesian(xmin=log10(10), xmax=log10(1000), ymin = log10(0.08), ymax =log10(2)))

    p0 = plot(layers..., guides..., scales..., coords..., Theme(key_swatch_color="slategrey"))
end

κs = [0;0.0001:0.0001:0.0009;0.001:0.001:0.009;0.01:0.01:1;1.1;1.2;1.3]
κ4 = slider(κs; value = 0.4, label = "Hygroscopicity (-)", throttle=1.0)
display(κ4)
p = map(ccn_app4, κ4)