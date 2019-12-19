using Printf, Colors, Gadfly, Interpolations, Interact

A = 2.1e-9
S(D,Dd,κ) = (D^3.0 - Dd^3.0)/(D^3.0 - Dd^3.0*(1.0-κ))*exp(A/D)
sc(Dd,κ) = (maximum(S.(collect(range.(Dd*1.01,stop=60.0*Dd,length=500)),Dd,κ))-1.0)*100.0
gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function ccn_app2(sch,κ)
    Gadfly.set_default_plot_size(15Gadfly.cm, 8Gadfly.cm)
    colors = ["black", "steelblue3", "darkred" ]
    
    Dd = exp10.(range(log10(10e-9), stop=log10(3e-6),length=100))
    msc = sc.(Dd,κ)

    itp = interpolate((reverse(msc),),reverse(Dd),Gridded(Linear()))
    extp = extrapolate(itp, 10e-6)
    Dact = extp(sch)

    layers = []
    push!(layers,layer(x = Dd*1e9, y = msc, 
         color = ["Köhler Theory" for i=1:length(Dd)], Geom.line))

    label1 = @sprintf("Environmental s = %.1f", sch).*"%"
    push!(layers,layer(x = [1.0,Dact*1e9], y = [sch,sch], color = [label1 for i = 1:2],
          Geom.line,Geom.point,
          Theme(alphas=[0.3],discrete_highlight_color=cfun, highlight_width=1Gadfly.pt)))

    label = @sprintf("Activation diameter = %.1f nm", Dact.*1e9)
    push!(layers,layer(x = [Dact,Dact].*1e9, y = [0.01,sch], color = [label for i = 1:2],
           Geom.line,Geom.point,
           Theme(alphas=[0.3],discrete_highlight_color=cfun, highlight_width=1Gadfly.pt)))
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

    p0 = plot(layers..., guides..., scales..., coords...)   
end

κs = [0;0.0001:0.0001:0.0009;0.001:0.001:0.009;0.01:0.01:1;1.1;1.2;1.3]
κ = slider(κs; value = 0.6, label = "Hygroscopicity (-)")
sch = slider([0.09;0.1:0.1:2]; value = 0.3, label = "Environmental supersaturation (%)")
display(hbox( pad(0.5em, sch), pad(0.5em, κ)))
p = map((i,j)->ccn_app2(i,j), sch, κ)