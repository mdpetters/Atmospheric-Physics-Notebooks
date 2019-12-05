using AtmosphericThermodynamics, Gadfly, Printf, Interact

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

function mplt(T,p,ρ)  
    Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)
    Dp = gengrid(exp10.(-9:1:-4))

    xnames = Dict(-9 =>"1 nm",-8=>"10 nm",-7=>"100 nm",-6=> "1 μm",-5=>"10 μm",-4=>"100 μm",-3=>"1 mm")
    ynames = Dict(-9=>"1 nm/s",-6=>"1 μm/s",-3=>"1 mm/s",0=>"1 m/s")

    plot(x=Dp, y=vt.(Dp;T=T[]+273.15,p=p[]*100.0,ρp=ρp[]),Geom.line,Theme(default_color="black"),
         Guide.xlabel("Particle diameter"), Guide.ylabel("Terminal velocity"),
         Guide.xticks(ticks = -9:1:-3), Guide.yticks(ticks = -9:1:1),
         Scale.x_log10(labels = i->get(xnames, i, "")),
         Scale.y_log10(labels = i->get(ynames, i, "")),
         Coord.cartesian(xmin=-9, xmax=-3,ymin = -9, ymax = 1))
end

T = togglebuttons(OrderedDict("-50"=>-50.0, "20"=>20.0), value = 20.0, label = "T (°C)")
p = togglebuttons(OrderedDict("10"=>10.0, "1000"=>1000.0), value = 1000.0, label = "P (hPa)")
ρp = togglebuttons(OrderedDict("1000"=>1000.0, "2500"=>2500.0), value = 1000.0, label = "ρ (kg m-3)")
display(hbox(T,p,ρp))
map(mplt, T, p, ρp)
