
g = 9.81
cp = 1005.0
Lv = 3.3e6
Γd = g/cp
Γdew = 1.9e-3
Rd = 287.05
Rv = 461.5
p0 = 1000.0
z = 0:0.01:1
T0 = 20.0

ΔT = 4.0
@manipulate for ΔT = 2:0.2:5  
    Gadfly.set_default_plot_size(24Gadfly.cm, 7Gadfly.cm)
    es(T::Float64) = 610.94*exp(17.625*T/(T+243.04))
    es1 = es(T0)
    es2 = es(T0 + ΔT)

    m = (es2-es1)
    e = es1 .+ m.*z
    T = T0 .+ ΔT.*z
    esp = es.(T)
    s = @. 100*(e/es(T)-1.0)

    layers = []
    push!(layers, layer(x=[T0, T0+ΔT], y = [0, 1.0], Geom.line, Geom.point, Theme(default_color = "black")))

    guides = []
    push!(guides, Guide.xlabel("Temperature (C)"))
    push!(guides, Guide.ylabel("Height (cm)"))
    push!(guides, Guide.title("Thermal Profile"))
    
    scales = []
    coords = []    
    push!(coords,Coord.cartesian(xmin=19, xmax=27, ymin = 0, ymax = 1))

    p1 = plot(layers..., guides..., scales..., coords...)   

    #---------------------------------------------------------------------------
    layers = []
    push!(layers, layer(x=[es1, es2]./100, y = [0, 1.0],Geom.point, Geom.line, Theme(default_color = "black")))

    guides = []
    push!(guides, Guide.xlabel("Pressure (hPa)"))
    push!(guides, Guide.ylabel("Height (cm)"))
    push!(guides, Guide.title("Vapor Profile"))
    
    scales = []
    coords = []    
    push!(coords,Coord.cartesian(xmin=22, xmax=34, ymin = 0, ymax = 1))

    p2 = plot(layers..., guides..., scales..., coords...)   


    #---------------------------------------------------------------------------
    layers = []
    push!(layers, layer(x=s, y=collect(z), Geom.line(preserve_order=true), Theme(default_color = "black")))

    guides = []
    push!(guides, Guide.xlabel("Supersaturation (%)"))
    push!(guides, Guide.ylabel("Height (cm)"))
    push!(guides, Guide.title("Supersaturation Profile"))
    
    scales = []
    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=1, ymin = 0, ymax = 1))

    p3 = plot(layers..., guides..., scales..., coords...)

     hstack(p1, p2, p3)
end