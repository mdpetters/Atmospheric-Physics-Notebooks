using Printf

function mp(i,j)
    Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)
    C = parse(Float64,i)
    k = parse(Float64,j)
    s = exp10.(range(log10(0.001), stop = log10(2), length = 100))
    N = @. C*s^k

    guides = []
    push!(guides, Guide.xlabel("Supersaturation (%)"))
    push!(guides, Guide.ylabel("Number concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.title("N = Cs<sup>k</sup> (linear scale)"))

    scales = []
    push!(scales, Scale.x_continuous())
    push!(scales, Scale.y_continuous())
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=2, ymin = 0, ymax = 2000))

    p0 = plot(x = s, y = N, Theme(default_color = "steelblue3"), Geom.line, guides..., scales..., coords...)   

    # --------------------------------------------------------------------------
    xticks = log10.([0.08;0.09;collect(0.1:0.1:1);2])
    xtlabel = [0.1, 1]
    ytlabel = [1, 10, 100, 1000]
    yticks = log10.([1:1:10;20:10:100;200:100:1000])

    lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("%.1f", exp10(x)), "")
    lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

    guides = []
    push!(guides, Guide.xlabel("Supersaturation (%)"))
    push!(guides, Guide.ylabel("Number concentration (cm<sup>-3</sup>)"))
    push!(guides, Guide.title("N = Cs<sup>k</sup> (logarithmic scale)"))

    scales = []
    push!(scales, Scale.x_log10(labels = lfunx))
    push!(scales, Scale.y_log10(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))

    coords = []
    push!(coords,Coord.cartesian(xmin=log10(0.08), xmax=log10(2), ymin = log10(1), ymax = log10(2000)))

    p1 = plot(x = s, y = N, Theme(default_color = "steelblue3"), Geom.line, guides..., scales..., coords...)   

    hstack(p0,p1)
end

C = widget(["50", "100", "200", "500", "1000"]; value = "200")
k = widget(["0.1", "0.5", "1.0"]; value = "0.5")
p = map((i,j)->mp(i,j), observe(C), observe(k))
display(p)
display("     C-values               k-values")
ui = hbox( pad(0.5em, C), pad(0.5em, k))
display(ui)