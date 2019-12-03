using Gadfly, CSV

function collision_app5()
    df1 = CSV.read("figures/Beard 3 mm.txt")
    df2 = CSV.read("figures/Beard 4 mm.txt")
    df3 = CSV.read("figures/Beard 5 mm.txt")
    df4 = CSV.read("figures/Beard 6 mm.txt")
                        
    Gadfly.set_default_plot_size(30Gadfly.cm, 7Gadfly.cm)

    p1 = plot(layer(x=df1[!,:x], y=df1[!,:y], color = ["Shape" for i = 1:length(df1[!,:x])], 
                 Theme(line_width=2Gadfly.pt), Geom.path),
        layer(x = [-1.6], y = [0.0], xend = [1.6], yend = [0.0], color = ["l<sub>1</sub> = 3.2"], Geom.segment),
        layer(x = [0], y = [-1.35], xend = [0], yend = [1.35], color = ["l<sub>2</sub> = 2.7"], Geom.segment),
        Guide.xlabel("Distance (mm)"), Guide.ylabel("Distance (mm)"),
        Guide.title("3 mm drop"), 
        Scale.x_continuous(minvalue=-4, maxvalue=4),
        Scale.y_continuous(minvalue=-4, maxvalue=4),
        Scale.color_discrete_manual("black", "steelblue3", "darkred"),
        Guide.xticks(ticks = -4:1:4), Guide.yticks(ticks = -4:1:4),
        Coord.cartesian(xmin=-4, xmax=4,ymin = -4, ymax = 4))

    p2 = plot(layer(x=df2[!,:x], y=df2[!,:y], color = ["Shape" for i = 1:length(df2[!,:x])],
            Theme(line_width=2Gadfly.pt), Geom.path),
        layer(x = [-2.15], y = [-0.38], xend = [2.15], yend = [-0.38], color = ["l<sub>1</sub> = 4.3"], Geom.segment),
        layer(x = [0], y = [-1.7], xend = [0], yend = [1.7], color = ["l<sub>2</sub> = 3.4"], Geom.segment),
        Scale.x_continuous(minvalue=-4, maxvalue=4),
        Scale.y_continuous(minvalue=-4, maxvalue=4),
        Guide.xlabel("Distance (mm)"), Guide.ylabel("Distance (mm)"),
        Guide.title("4 mm drop"), 
        Scale.color_discrete_manual("black", "steelblue3", "darkred"),
        Guide.xticks(ticks = -4:1:4), Guide.yticks(ticks = -4:1:4),
        Coord.cartesian(xmin=-4, xmax=4,ymin = -4, ymax = 4))

    p3 = plot(layer(x=df3[!,:x], y=df3[!,:y], color = ["Shape" for i = 1:length(df3[!,:x])],
        Theme(line_width=2Gadfly.pt), Geom.path),
    layer(x = [-2.9], y = [-0.6], xend = [2.9], yend = [-0.6], color = ["l<sub>1</sub> = 5.8"], Geom.segment),
    layer(x = [0], y = [-2.05], xend = [0], yend = [2.05], color = ["l<sub>2</sub> = 4.1"], Geom.segment),
    Scale.x_continuous(minvalue=-4, maxvalue=4),
    Scale.y_continuous(minvalue=-4, maxvalue=4),
    Guide.xlabel("Distance (mm)"), Guide.ylabel("Distance (mm)"),
    Guide.title("5 mm drop"), 
    Scale.color_discrete_manual("black", "steelblue3", "darkred"),
    Guide.xticks(ticks = -4:1:4), Guide.yticks(ticks = -4:1:4),
    Coord.cartesian(xmin=-4, xmax=4,ymin = -4, ymax = 4))

    p4 = plot(layer(x=df4[!,:x], y=df4[!,:y], color = ["Shape" for i = 1:length(df4[!,:x])],
        Theme(line_width=2Gadfly.pt), Geom.path),
    layer(x = [-3.61], y = [-0.8], xend = [3.61], yend = [-0.8], color = ["l<sub>1</sub> = 7.2"], Geom.segment),
    layer(x = [0], y = [-2.27], xend = [0], yend = [2.25], color = ["l<sub>2</sub> = 4.5"], Geom.segment),
    Scale.x_continuous(minvalue=-4, maxvalue=4),
    Scale.y_continuous(minvalue=-4, maxvalue=4),
    Guide.xlabel("Distance (mm)"), Guide.ylabel("Distance (mm)"),
    Guide.title("6 mm drop"), 
    Scale.color_discrete_manual("black", "steelblue3", "darkred"),
    Guide.xticks(ticks = -4:1:4), Guide.yticks(ticks = -4:1:4),
    Coord.cartesian(xmin=-4, xmax=4,ymin = -4, ymax = 4))

    hstack(p1,p2,p3,p4)
end

collision_app5()