using Gadfly, Compose, Colors, Interact, AtmosphericThermodynamics, CSV, Printf

dfA8 = CSV.read("figures/Ec.csv"; header=false)
RxA8 = convert(Array{Float64}, dfA8[2:end,1])
rxA8 = convert(Array{Float64}, Vector(dfA8[1,2:end]))
Ec = Matrix(dfA8[2:end,2:end])

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]


function collision_app8(i)

    Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)
    Et = Ec[i,:]
    y = Et[.~ismissing.(Et)]
    x = rxA8[.~ismissing.(Et)]
    str = "R = "*id[i]*" μm"
    l = [str for j = 1:length(x)]

    Et = Ec[1,:]
    y1 = Et[.~ismissing.(Et)]
    x1 = rxA8[.~ismissing.(Et)]
    str = "R = "*id[1]*" μm"
    l1 = [str for j = 1:length(x1)]
    
    Et = Ec[end,:]
    y2 = Et[.~ismissing.(Et)]
    x2 = rxA8[.~ismissing.(Et)]
    str = "R = "*id[end]*" μm"
    l2 = [str for j = 1:length(x2)]

    ynames = Dict(-2 =>"0.01",-1 =>"0.1",0 =>"1")

    function lfun(i)
        if i == -2
            "0.01"
        elseif i == -1
            "0.1"
        elseif i == 0
            "1"
        else
            ""
        end
    end
    plot(layer(x = x1, y = y1, Geom.line, Geom.point, color = l1),
         layer(x = x, y = y, Geom.line, Geom.point, color = l),
         layer(x = x2, y = y2, Geom.line, Geom.point, color = l2),
        Guide.yticks(ticks = log10.(gengrid([0.01,0.1]))),
        Guide.xlabel("Cloud drop radius, r (μm)"),
        Guide.ylabel("Collision efficiency (-)"),
        Scale.y_log10(labels = lfun),
        Scale.color_discrete_manual("black", "steelblue3", "darkgoldenrod3"),
        Coord.cartesian(xmin = 0, xmax = 30,ymin = log10(0.01), ymax = 0))
end

vals = OrderedDict("20 μm"=>2,"30 μm"=>3, "40 μm"=>4,"50 μm"=>5, 
            "60 μm"=>6,"80 μm"=>7, "150 μm"=>9,"200 μm"=>10,
            "300 μm"=>11,"400 μm"=>12, "500 μm"=>13,
            "1 mm"=>15,"1.4 mm"=>16, "1.8 mm"=>17,"2.4 mm"=>18)
id = map(i->@sprintf("%i",i),RxA8   )
RCA8 = togglebuttons(vals, value  = 3)
display(RCA8)
map(collision_app8, RCA8)