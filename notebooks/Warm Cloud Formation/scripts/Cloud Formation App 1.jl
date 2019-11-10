using Gadfly, Interact

function mp1(i,j) 
    Gadfly.set_default_plot_size(24Gadfly.cm, 7Gadfly.cm)
    g = 9.81
    cp = 1005.0
    Lv = 3.3e6
    Γd = g/cp
    Γdew = 1.9e-3
    Rd = 287.05
    Rv = 461.5
    p0 = 1000.0

    T0 = parse(Float64,i)
    Tdew0 = parse(Float64,j)
    zLCL = (T0-Tdew0)/(Γd-Γdew)
    TLCL = T0 - Γd*zLCL
    pLCL = p0*((TLCL + 273.15)/(T0+273.15))^(cp/Rd)
    es = 6.1094*exp(17.625*TLCL/(TLCL + 243.04))
    ws = 0.622*es/(pLCL-es)
    Γs = Γd*(1+(Lv*ws)/(Rd*(TLCL+273.15)))/(1+(Lv^2*ws)/(cp*Rv*(TLCL+273.15)^2)) 

    function T(z, zLCL)
        fa = @. z -> T0 - Γd*z
        fb = @. z -> TLCL - Γs*(z-zLCL)
        return [fa(z[z .<= zLCL]); fb(z[z .> zLCL])]
    end
    function Tdew(z, zLCL)
        fa = @. z -> Tdew0 - Γdew*z
        fb = @. z -> TLCL - Γs*(z-zLCL)
        return [fa(z[z .<= zLCL]); fb(z[z .> zLCL])]
    end
    function wl(z, zLCL)
        fa = @. z -> z*0.0
        fb = @. z -> cp/Lv*(Γd - Γs)*(z-zLCL)
        return [fa(z[z .<= zLCL]); fb(z[z .> zLCL])]
    end

    es1 = T -> 6.1094*exp(17.625*T/(T + 243.04))
    RH = z -> es1.(Tdew(z,zLCL))./es1.(T(z,zLCL)) .* 100.0
 
    z = 0:100:4000.0
    layers = []
    push!(layers, layer(x = [T0], y = [0], color = ["T"]))
    push!(layers, layer(x = T(z,zLCL), y=z./1000, color = ["T" for i in z], Geom.line))
    push!(layers, layer(x = [Tdew0], y = [0], color = ["Tdew"]))
    push!(layers, layer(x = Tdew(z,zLCL), y=z./1000, color = ["Tdew" for i in z], Geom.line))
    push!(layers, layer(x = [-40,100], y=[zLCL, zLCL]./1000, color = ["zLCL", "zLCL" ], Geom.line))

    guides = []
    push!(guides, Guide.xlabel("Temperature (°C)"))
    push!(guides, Guide.ylabel("Height (km)"))
    push!(guides, Guide.title("Temperature profile"))

    scales = []
    push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))
    
    coords = []    
    push!(coords,Coord.cartesian(xmin=-40, xmax=20, ymin = 0, ymax = 4))
    p1 = plot(layers..., guides...,scales...,coords...)

    layers = []
    push!(layers, layer(x = RH(z), y=z./1000, color = ["RH" for i in z], Geom.line))
    push!(layers, layer(x = [0,100], y=[zLCL, zLCL]./1000, color = ["zLCL", "zLCL" ], Geom.line))

    guides = []
    push!(guides, Guide.xlabel("Relative Humidity (%)"))
    push!(guides, Guide.ylabel("Height (km)"))
    push!(guides, Guide.title("RH profile"))
    push!(guides, Guide.xticks(ticks=collect(0:20:100)))

    scales = []
    push!(scales, Scale.color_discrete_manual("black", "darkgoldenrod3", "darkred", "steelblue3"))
    
    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=100, ymin = 0, ymax = 4))
    p2 = plot(layers..., guides..., scales..., coords...)

    layers = []
    push!(layers, layer(x = wl(z,zLCL).*1000.0, y=z./1000, color = ["wl" for i in z], Geom.line))
    push!(layers, layer(x = [0,100], y=[zLCL, zLCL]./1000, color = ["zLCL", "zLCL" ], Geom.line))

    guides = []
    push!(guides, Guide.xlabel("Mixing ratio (g/kg)"))
    push!(guides, Guide.ylabel("Height (km)"))
    push!(guides, Guide.title("Liquid water profile"))

    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=2, ymin = 0, ymax = 4))
    p3 = plot(layers..., guides..., scales..., coords...)

    hstack(p1,p2,p3)
end

T0 = widget(["0", "5", "10", "15", "20"]; value = "10")
Tdew0 = widget(["-20", "-15", "-10", "-5", "0"]; value = "0")
p1 = map((i,j)->mp1(i,j), observe(T0), observe(Tdew0))
display(p1)
display("   Tdew-values             T-values")
display(hbox(pad(0.5em, Tdew0), pad(0.5em, T0)))