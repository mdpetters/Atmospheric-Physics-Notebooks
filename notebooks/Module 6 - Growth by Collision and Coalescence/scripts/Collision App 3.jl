using AtmosphericThermodynamics, Gadfly, Printf, Interact

λ(T::Float64,p::Float64) = 6.6e-8*(101315.0/p)*(T/293.15)                             # Mean free path of air
η(T::Float64) = 1.83245e-5*exp(1.5*log(T/296.1))*(406.55)/(T+110.4)                   # viscosity of air
Cc(T::Float64,p::Float64,d::Float64) = 1.0+λ(T,p)/d*(2.34+1.05*exp.(-0.39*d/λ(T,p)))  # Slip correction
ρg(T::Float64,p::Float64) = p/(Rd*T)                                                  # Air density
Re(v::Float64,d::Float64,T::Float64,p::Float64) = ρg(T,p)*v*d/η(T)                    # Reynolds number
Cd(Re::Float64) = (Re < 0.1) ? 24.0/Re : 24.0/Re.*(1+0.15*Re^0.687)                   # Drag coefficient 

function vt(d::Float64;T=298.15,p=1e5,ρp=1e3)  
    vts1 = (d,v) -> (4.0*ρp*d*g*Cc(T,p,d)/(3.0*Cd(Re(v,d,T,p))*ρg(T,p)))^0.5
    vts2 = (d,v) -> (vts1(d,v)-v)^2.0 < 1e-30 ? v : vts2(d,vts1(d,v))
    vts2(d, 1e-5)
end

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]


function mplt(T,p,ρ)  
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
