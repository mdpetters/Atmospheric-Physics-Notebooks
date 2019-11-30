using Printf, Colors, Gadfly, Interact, SpecialFunctions, DataFrames


A = 2.1e-9
S(D,Dd,κ) = (D^3.0 - Dd^3.0)/(D^3.0 - Dd^3.0*(1.0-κ))*exp(A/D)
sc(Dd,κ) = (maximum(S.(collect(range.(Dd*1.01,stop=60.0*Dd,length=500)),Dd,κ))-1.0)*100.0
gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function ccn_app4(κ,Nt,Dg,σg,on)
    Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)
    colors = ["black",  "darkred", "steelblue3" ]
    
    ψ(s) = (4.0/27.0)^(1.0/3.0)*A/(κ^(1.0/3.0)*Dg.*1e-9*log(s/100.0+1.0)^(2.0/3.0))
    Af(s) =  Nt*1/2*erfc(log.(ψ.(s))/(sqrt(2.0)*log(σg)))
    s = exp10.(range(log10(0.1), stop = log10(2), length = 100))
    sx = [0.2,0.4,0.6,0.8, 1.0]

    df = DataFrame(s = s, y = Af.(s), col = ["Nccn continuous" for i = 1:length(s)])
    df1 = DataFrame(s = sx, y = Af.(sx), col = ["Nccn discrete" for i = 1:length(sx)])

    colors = ["black",  "darkred", "slategrey" ]

    p1 = plot(layer(x=df[!,:s], y = df[!,:y], color = df[!,:col], Geom.line),
              layer(x=df1[!,:s], y = df1[!,:y], color = df1[!,:col], Geom.point),
              Guide.xlabel("Supersaturation (%)"),
              Guide.ylabel("Number concentration (cm<sup>-3</sup>)"),
              Scale.color_discrete_manual(colors...),
              Scale.x_continuous(),
              Scale.y_continuous(),
              Coord.cartesian(xmin=0, xmax=2, ymin = 0, ymax = 2000))
    

    # --------------------------------------------------------------------------
    xticks = log10.([0.08;0.09;collect(0.1:0.1:1);2])
    xtlabel = [0.1, 1]
    ytlabel = [1, 10, 100, 1000]
    yticks = log10.([1:1:10;20:10:100;200:100:1000])

    lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("%.1f", exp10(x)), "")
    lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

    layers = []
    push!(layers,layer(x=df[!,:s], y = df[!,:y], color = df[!,:col], Geom.line))
    push!(layers,layer(x=df1[!,:s], y = df1[!,:y], color = df1[!,:col], Geom.point))

    guides = []
    push!(guides, Guide.xlabel("Supersaturation (%)"))
    push!(guides, Guide.ylabel("Number concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.xticks(ticks=xticks))
    push!(guides, Guide.yticks(ticks=yticks))

    scales = []
    push!(scales, Scale.x_log10(labels = lfunx))
    push!(scales, Scale.y_log10(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

    coords = []
    push!(coords,Coord.cartesian(xmin=log10(0.08), xmax=log10(2), ymin = log10(1), ymax = log10(2000)))

    p2 = plot(layers...,  guides..., scales..., coords...)   

    if on
        hstack(p1,p2)
    end
end

onoff = widget(false)
display(onoff)
p = map((κ,Nt,Dg,σg,on)->ccn_app4(κ,Nt,Dg,σg,on), observe(κ3), observe(Nt), observe(Dg), observe(σg), observe(onoff))