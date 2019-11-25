using AtmosphericThermodynamics, Gadfly, Colors, Interact

function condensation_app4(p)
    Gadfly.set_default_plot_size(14Gadfly.cm, 9Gadfly.cm)
    ylabel = [-8,-9,-10]
    lfuny = x->ifelse(sum(x .== ylabel) == 1, @sprintf("10<sup>-%i</sup>",x), "")

    plot(T->100*G(T+273.15,p), -60,30, Theme(default_color=colorant"black"),
         Guide.xlabel("Temperature (°C)"),
         Guide.ylabel("G (m<sup>2</sup> s</sup>-1</sup> %<sup>-1</sup> supersat.)"),
         Guide.xticks(ticks=-60:10:30),
         Guide.yticks(ticks=log10.([5e-11:1e-11:9e-11;1e-10:1e-10:9e-10;1e-9;2e-9])),
         Scale.y_log10(labels=lfuny),
         Coord.cartesian(xmin=-60, xmax=30, ymin = log10(5e-11), ymax = log10(2e-9)))
end

p = slider(reverse(collect(10:10:100).*10), value = 1000, label = "Pressure (hPa)")
display(p)
display(map((i)->condensation_app4(i*100), observe(p)))