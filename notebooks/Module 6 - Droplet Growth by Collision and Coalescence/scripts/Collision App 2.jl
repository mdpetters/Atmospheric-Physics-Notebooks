using AtmosphericThermodynamics, Gadfly, Printf, Interact, NumericIO

vtx(τ::Float64, d::Float64, t::Array{Float64,1}) = @. vt(d)*(1.0-exp(-t/τ))

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

function collision_app2(d)
    Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)

    xnames = Dict(0 =>"0",1 =>"1 τ",2 =>"2 τ",3 =>"3 τ",4 =>"4 τ",5 =>"5 τ",6 =>"6 τ")
    T,p,ρp = 298.15, 1e5, 1000.0
    τ = ρp*d^2.0*Cc(T,p,d)/(18.0*η(T))
    t = collect(0.0:0.1:6.0)
    vt(d)

    label1 = "v<sub>t</sub> = "*formatted(vt(d), :SI, ndigits=3)*"m s<sup>-1</sup>"
    label2 = "τ =  "*formatted(τ, :SI, ndigits=3)*"s"
    plot(layer(x=[1,1], y=[-10,1-1.0/exp(1.0)],color = [label2 for i = 1:2], Geom.line, Geom.point),
         layer(x=t, y=(1.0.-exp.(-t)),color = [label1 for i = 1:length(t)], Geom.line),
         Scale.color_discrete_manual("darkgoldenrod3", "black"),
         Guide.xlabel("Time"), Guide.ylabel("Velocity"),
         Guide.xticks(ticks = [0,1,2,3,4,5,6]),
         Guide.yticks(ticks = 0:0.1:1),
         Scale.x_continuous(labels = i->xnames[round(Int,i)]),
         Scale.y_continuous(labels = i->@sprintf("%.1f v<sub>t</sub>",i)),
         Coord.cartesian(xmin=0, xmax=6.0, ymin = 0))

end

dsd = togglebuttons(OrderedDict("1 nm"=>1e-9,"10 nm"=>10e-9, "100 nm"=>100e-9,"1 μm"=>1e-6, 
                              "10 μm"=>10e-6,"100 μm"=>100e-6,"1000 μm"=>1000e-6), value = 100e-9, label = "Diameter")
display(dsd)
map(collision_app2, dsd)