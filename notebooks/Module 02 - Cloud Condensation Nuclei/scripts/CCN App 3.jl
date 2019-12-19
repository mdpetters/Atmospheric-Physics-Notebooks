using Printf, Colors, Gadfly, Interpolations, Interact, DifferentialMobilityAnalyzers


A = 2.1e-9
S(D,Dd,κ) = (D^3.0 - Dd^3.0)/(D^3.0 - Dd^3.0*(1.0-κ))*exp(A/D)
sc(Dd,κ) = (maximum(S.(collect(range.(Dd*1.01,stop=60.0*Dd,length=500)),Dd,κ))-1.0)*100.0
gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function ccn_app3(sch,κ,Nt,Dg,σg)
    Gadfly.set_default_plot_size(26Gadfly.cm, 8Gadfly.cm)
    colors = ["black",  "darkred", "steelblue3" ]
    
    Dd = exp10.(range(log10(10e-9), stop=log10(3e-6),length=100))
    msc = sc.(Dd,κ)

    itp = interpolate((reverse(msc),),reverse(Dd),Gridded(Linear()))
    extp = extrapolate(itp, 10e-6)
    Dact = extp(sch)

    layers = []
    push!(layers,layer(x = Dd*1e9, y = msc, 
         color = ["Köhler Theory" for i=1:length(Dd)], Geom.line))

    label = @sprintf("Activation diameter = %.1f nm", Dact.*1e9)
    push!(layers,layer(x = [Dact,Dact].*1e9, y = [0.01,sch], color = [label for i = 1:2],
           Geom.line,Geom.point,
           Theme(alphas=[0.3],discrete_highlight_color=cfun, highlight_width=1Gadfly.pt)))
          guides = []
    label1 = @sprintf("Environmental s = %.1f", sch).*"%"
          push!(layers,layer(x = [1.0,Dact*1e9], y = [sch,sch], color = [label1 for i = 1:2],
                Geom.line,Geom.point,
                Theme(alphas=[0.3],discrete_highlight_color=cfun, highlight_width=1Gadfly.pt)))
      
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

    𝕗 = lognormal([[Nt, Dg, σg]]; d1 = 1.0, d2 = 1000.0, bins = 300); 
	𝕘 = deepcopy(𝕗)
    xlabel = log10.([10, 100, 1000])
    lfunx = x->ifelse(sum(x .== xlabel) == 1, @sprintf("%i",exp10(x)), "")

    Nmax1 = (𝕘.S[𝕘.Dp .> Dact.*1e9])[1]
    𝕘.S[𝕘.Dp .< Dact.*1e9] .= 0.0
    𝕘.N[𝕘.Dp .< Dact.*1e9] .= 0.0
    Nccn = sum(𝕘.N)
    label1 = [@sprintf("D<sub>activation</sub> %.1f nm", Dact*1e9) for i = 1:2]
    label3 = [@sprintf("N shaded area = %.1f cm<sup>-3</sup>", Nccn)  for i=1:300]
    l0 = layer(x=𝕗.Dp, y = 𝕗.S, color = ["Size distribution" for i=1:300], Geom.line)
    l1 = layer(x = [Dact, Dact].*1e9, y = [-2e3,Nmax1], color = label1, Geom.line, Geom.point,
         Theme(alphas=[0.5],discrete_highlight_color=cfun,highlight_width=0Gadfly.pt))
    colors = ["black",  "darkred", "slategrey" ]

    l3 = layer(x=𝕘.Dp,y=𝕘.S,color=label3, Geom.bar, Theme(bar_highlight=c->RGBA(0.7,0.7,0.7,1)))

    p1 = plot(l0, l1, l3,
            Guide.xlabel("Particle diameter (nm)"),
            Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
            Guide.title("Lognormal Size Distribution"),
            Scale.color_discrete_manual(colors...),
            Guide.xticks(ticks = log10.(gengrid([10,100]))),
            Scale.x_log10(labels = lfunx),
            Coord.cartesian(xmin=log10(10), xmax=log10(1000),ymin = 0)) 

    hstack(p0,p1)
end

Dg = slider(gengrid([10,100]), value = 50, label = "Dg (nm)")
Nt = slider(gengrid([10,100,1000]), value = 1000, label = "Nt (cm-3)")
σg = slider(1.1:0.1:2, value = 1.9, label = "σg (-)")
b1 = hbox(pad(0.5em, Nt), pad(0.5em, Dg))
display(hbox(b1, pad(0.5em,σg)))

κs = [0;0.0001:0.0001:0.0009;0.001:0.001:0.009;0.01:0.01:1;1.1;1.2;1.3]
κ3 = slider(κs; value = 0.3, label = "Hygroscopicity (-)")
sch3 = slider([0.09;0.1:0.1:2]; value = 0.3, label = "Environmental supersaturation (%)")
display(hbox( pad(0.5em, sch3), pad(0.5em, κ3)))
p = map((i,j,Nt,Dg,σg)->ccn_app3(i,j,Nt,Dg,σg), sch3, κ3, Nt, Dg, σg)


