using AtmosphericThermodynamics, Gadfly, Printf, Interact

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

function collision_app4()  
    Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)
    Dp1 = gengrid(exp10.(-9:1:-4))
    Dp = [Dp1;[2e-3]]
    xnames = Dict(-7=>"100 nm",-6=> "1 μm",-5=>"10 μm",-4=>"100 μm",-3=>"1 mm", -2=>"10 mm")
    ynames = Dict(-7=>"100 nm/s",-6=>"1 μm/s",-5=>"10 μm/s",-4=>"100 μm/s",-3=>"1 mm/s",-2=>"10 mm/s",-1=>"100 mm/s",0=>"1 m/s",1=>"10 m/s")
    
    vt1(D) = 3e7*D^2.0
    ii = (Dp .<= 100e-6) .& (Dp .>= 1.2e-9)
    vt2(D) = 4e3*D
    jj = (Dp .>= 100e-6) .& (Dp .<= 1.2e-3)
    Dx = 1e-3:1e-3:1e-2
    vt3(D) = 9.65-10.3exp(-600.0*D)
    ll = (Dx .>= 1000e-6) .& (Dx .>= 1.2e-9)
    label1 = ["v<sub>t</sub> = 3×10<sup>7</sup> D<sup>2</sup>" for i = 1:length(Dp)]
    label2 = ["v<sub>t</sub> = 4×10<sup>3</sup> D" for i = 1:length(Dp)]
    label3 = ["v<sub>t</sub> = 9.65 - 10.3e<sup>-600D</sup>" for i = 1:length(Dx)]
    label4 = ["Numerical solution" for i = 1:length(Dp)]

    plot(layer(x=Dp[ii], y=vt1.(Dp[ii]),color=label1[ii], Theme(line_width=1.5Gadfly.pt, line_style=[:dash]), Geom.line),
         layer(x=Dp[jj], y=vt2.(Dp[jj]),color=label2[jj], Theme(line_width=1.5Gadfly.pt, line_style=[:dash]), Geom.line),
         layer(x=Dx[ll], y=vt3.(Dx[ll]),color=label3[ll], Theme(line_width=1.5Gadfly.pt, line_style=[:dash]), Geom.line),
         layer(x=Dp, y=vt.(Dp),color=label4, Theme(line_width=2Gadfly.pt), Geom.line),
         Guide.xlabel("Particle diameter"), Guide.ylabel("Terminal velocity"),
         Scale.color_discrete_manual("darkgoldenrod3", "salmon", "steelblue3", "black"),
         Guide.xticks(ticks = -9:1:-2), Guide.yticks(ticks = -9:1:1),
         Scale.x_log10(labels = i->get(xnames, i, "")),
         Scale.y_log10(labels = i->get(ynames, i, "")),
         Coord.cartesian(xmin=-7, xmax=-2,ymin = -7, ymax = 1.3))
end

collision_app4()