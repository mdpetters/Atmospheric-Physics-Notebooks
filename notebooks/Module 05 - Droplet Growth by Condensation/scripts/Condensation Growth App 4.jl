using AtmosphericThermodynamics, Gadfly, Colors, Interact

function condensation_app4(p)
    Gadfly.set_default_plot_size(15Gadfly.cm, 10Gadfly.cm)
    ylabel = [-14,-13,-12]
    lfuny = x->ifelse(sum(x .== ylabel) == 1, @sprintf("10<sup>%i</sup>",x), "")
    gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

    plot(T->G(T+273.15,p)./100  , -60,30, Theme(default_color=colorant"black"),
         Guide.xlabel("Temperature (°C)"),
         Guide.ylabel("G (m<sup>2</sup> s</sup>-1</sup> %<sup>-1</sup> supersat.)"),
         Guide.xticks(ticks=-60:10:30),
         Guide.yticks(ticks=log10.(gengrid([1e-15,1e-14,1e-13]))),
         Scale.y_log10(labels=lfuny),
         Coord.cartesian(xmin=-60, xmax=30, ymin = log10(5e-15), ymax = log10(2e-12)))
end

p = slider(reverse(collect(10:10:100).*10), value = 1000, label = "Pressure (hPa)")
display(p)
display(map((i)->condensation_app4(i*100), observe(p)))