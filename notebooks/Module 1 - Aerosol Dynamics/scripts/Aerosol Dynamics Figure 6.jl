using DifferentialMobilityAnalyzers, DataFrames, Gadfly, Interact, Colors, Printf

gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function aerosol_app1(Nt, Dg, σg)
    Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)
    𝕗 = lognormal([[Nt, Dg, σg]]; d1 = 1.0, d2 = 1000.0, bins = 1000); 
	𝕘 = deepcopy(𝕗)
    colors = ["black", "darkred", "steelblue3", "darkgrey"]
    xlabel = log10.([1, 10, 100, 1000])
    lfunx = x->ifelse(sum(x .== xlabel) == 1, @sprintf("%i",exp10(x)), "")

    Nmax1 = maximum(𝕗.S)
    Nmax2 = maximum(𝕘.S[(𝕘.Dp .> Dg*σg) .| (𝕘.Dp .< Dg/σg)])
    𝕘.S[(𝕘.Dp .> Dg*σg) .| (𝕘.Dp .< Dg/σg)] .= 0.0
    label1 = ["D<sub>pg</sub> = $Dg nm" for i=1:2]
    label2 = @sprintf("%.1f <  D<sub>pg</sub> < %.1f nm", Dg/σg, Dg*σg)
    label3 = [@sprintf("N shaded area = %.1f cm<sup>-3</sup>", 0.6827*Nt)  for i=1:1000]
    l0 = layer(x=𝕗.Dp, y = 𝕗.S, color = ["Lognormal function" for i=1:1000], Geom.line)
    l1 = layer(x = [Dg, Dg], y = [-2e3,Nmax1], color = label1, Geom.line, Geom.point,               
               Theme(alphas=[0.5],discrete_highlight_color=cfun,highlight_width=1Gadfly.pt))
    l2 = layer(x=[Dg],y=[Nmax2],xmin=[Dg/σg],xmax=[Dg*σg],color =[label2], Geom.errorbar,Geom.line)    
    l3 = layer(x=𝕘.Dp,y=𝕘.S,color=label3, Geom.bar)    

    p1 = plot(l0, l1, l2,l3,
            Guide.xlabel("Particle diameter (nm)"),
            Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
            Guide.title("Lognormal Size Distribution"),
            Scale.color_discrete_manual(colors...),
            Guide.xticks(ticks = log10.(gengrid([1,10,100]))),
            Scale.x_log10(labels = lfunx),
            Coord.cartesian(xmin=log10(1), xmax=log10(1000),ymin = 0)) 
end

Dg = slider(gengrid([1,10,100]), value = 100, label = "Dg (nm)")
Nt = slider(gengrid([10,100,1000]), value = 1000, label = "Nt (cm-3)")
σg = slider(1.1:0.1:2, value = 1.3, label = "σg (-)")
b1 = hbox(pad(0.5em, Nt), pad(0.5em, Dg))
display(hbox(b1, pad(0.5em,σg)))
display(map((Nt,Dg,σg)->aerosol_app1(Nt,Dg,σg), observe(Nt), observe(Dg), observe(σg)))