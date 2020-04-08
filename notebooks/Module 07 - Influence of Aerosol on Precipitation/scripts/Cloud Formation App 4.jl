using SpecialFunctions, Gadfly, Colors, Printf, Interact

import AtmosphericThermodynamics


function cloud_app4(T0, Tdew0, C, k, w0) 
    g = 9.81
    cp = 1005.0
    Lv = 2.5e6
    Γd = g/cp
    Γdew = 1.9e-3
    Rd = 287.05
    Rv = 461.5
    p0 = 1000.0
    z = 0:1.0:6000
    rhow = 1000.0
    s = 0.01:0.01:2
    w = 0.1:0.1:10

    T0 = parse(Float64,T0)
    Tdew0 = parse(Float64,Tdew0)
    if Tdew0 > T0
        Tdew0 = T0
    end
    
    Gadfly.set_default_plot_size(27Gadfly.cm, 8Gadfly.cm)
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
        Δz = collect(z .- zLCL)
        Δz[Δz .<= 0.0] .= 0.0
        AtmosphericThermodynamics.wl.(TLCL+273.15, zLCL, Δz)
    end
    
    zLCL0 = convert(Int, round(zLCL,digits = 0))

    Nccn = @. C*s^k
    wx = w*100.0
    BETA = beta(k/2.0,1.5)
    Nccn = @. C*s^k
    Nd = @. C^(2/(k+2)) * ( (1.6e-3*wx^1.5) / (k*BETA) ) ^ (k/(k+2.0))
    Nd0 = @. C^(2/(k+2)) * ( (1.6e-3*(w0.*100.0)^1.5) / (k*BETA) ) ^ (k/(k+2.0))
    smax = (1.6e-3*(w0*100)^1.5 / (C*k*BETA)) ^ (1/(k+2)) 

    RH = z -> 100.0 - 5.0*(T(z,zLCL)-Tdew(z,zLCL))

    es1 = T -> 6.1094*exp(17.625*T/(T + 243.04))
    RH = z -> es1.(Tdew(z,zLCL))./es1.(T(z,zLCL)) .* 100.0
    z = 0:10.0:8000.0
 
    p = @. 100*p0*exp(-z/8000.0)
    Tk = T(z,zLCL).+273.15
    rhoa = @. p/(Rd*Tk)
    wlx = wl(z,zLCL)
    LWC = @. wlx.*rhoa./1e6./rhow  # m3 water cm-3 air
    LWC1 = @. wlx.*rhoa # g water cm-3 air
    LWC2 = @. wlx./rhow  # m3 water kg-1 air
    Nd2 = @. Nd0.*1e6/rhoa[1] # CDNC kg-1 air
    Dm = @. (LWC*6/(π*Nd0))^(1/3.0)*1e6
    Dm = @. (LWC2*6/(π*Nd2))^(1/3.0)*1e6

    y = z[Dm .>= 24]
    wl0 = wl(z,zLCL)

    layers = []
    
    push!(layers, layer(x = wlx*1000, y=z./1000, color = ["LWC" for i = 1:length(z)], Geom.line(preserve_order=true)))
    push!(layers, layer(x = [-2.0,20], y=[zLCL, zLCL]./1000, color = ["LCL = $zLCL0 m" for i = 1:2], Geom.line(preserve_order=true)))

    if maximum(Dm) >= 24.0
        wl1 = wl0[Dm .>= 24]
        wl01 = (round(wl1[1]*1000,digits = 2))
        push!(layers, layer(x = [wl01,wl01], y = [-1000.0,y[1]]./1000, Geom.line(preserve_order=true), Geom.point,
        Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
        color = ["LWC = $wl01 g/kg" for i = 1:2]))
    
        delz = @sprintf("Δz = %i m", y[1]-zLCL)
        push!(layers, layer(x = [-100,wl01], y = [y[1],y[1]]./1000, Geom.line, Geom.point,
        Theme(alphas=[1.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
        color = [delz for i = 1:2]))
    end

    guides = []
    push!(guides, Guide.xlabel("LWC (g/kg)"))
    push!(guides, Guide.ylabel("Height (km)"))
    push!(guides, Guide.title("Liquid water profile"))
    push!(guides, Guide.yticks(ticks=0:1:8))

    scales = []
    push!(scales, Scale.color_discrete_manual("black", "darkgoldenrod3","darkred","steelblue3"))
    
    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=5, ymin = 0, ymax = 8))
    p1 = plot(layers..., guides...,scales...,coords...)



    # --------------------------------------------------------------------------
    Nd00 = round(Nd0,digits=1)

    xticks = log10.([collect(0.1:0.1:0.9);collect(1:1:10)])
    xtlabel1 = [0.1, 1, 10]
    ytlabel = [10, 100, 1000]
    yticks = log10.([1:1:10;20:10:100;200:100:1000])

    lfunx1 = x->ifelse(sum(exp10.(x) .== xtlabel1) == 1, @sprintf("%.2f", exp10(x)), "")
    lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")

    layers = []
    push!(layers, layer(x = w, y = Nd, Geom.line,
        color = ["CDNC = f(C,k,w)" for i = 1:length(w)]))

    push!(layers, layer(x = [w0, w0], y = [1, Nd0], Geom.line, Geom.point,
    Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
        color = ["w0 = $w0 m s<sup>-1</sup>" for i = 1:2]))

    push!(layers, layer(x = [0.001, w0], y = [Nd0, Nd0], Geom.line, Geom.point,
        color = ["CDNC = $Nd00 cm<sup>-3<sup>" for i = 1:2]))


    guides = []
    push!(guides, Guide.xlabel("Updraft velocity (m/s)"))
    push!(guides, Guide.ylabel("CDNC (cm<sup>-3</sup>)"))
    push!(guides, Guide.title("CDNC vs. updraft"))
    push!(guides, Guide.xticks(ticks=xticks))
    push!(guides, Guide.yticks(ticks=yticks))

    scales = []
    push!(scales, Scale.x_log10(labels = lfunx1))
    push!(scales, Scale.y_log10(labels = lfuny))
    push!(scales, Scale.color_discrete_manual("black", "darkred", "steelblue3"))

    coords = []    
    push!(coords,Coord.cartesian(xmin=log10(0.1), xmax=log10(10.0), ymin = log10(8), ymax = log10(3000)))

    p2 = plot(layers..., guides...,scales...,coords...)


# --------------------------------------------------------------------------

    layers = []
    push!(layers, layer(x = Dm, y=z./1000, color = ["Mean drop diameter" for i = 1:length(z)], Geom.line(preserve_order=true)))
    push!(layers, layer(x = [-2.0,100], y=[zLCL, zLCL]./1000, color = ["LCL = $zLCL0 m" for i = 1:2], Geom.line))

    if maximum(Dm) >= 24.0
        push!(layers, layer(x = [24,24], y = [-2000, y[1]]./1000, Geom.line, Geom.point,
        Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
        color = ["Autoconversion" for i = 1:2]))

        delz = @sprintf("Δz = %i m", y[1]-zLCL)
        push!(layers, layer(x = [-100,24], y = [y[1],y[1]]./1000, Geom.line, Geom.point,
        Theme(alphas=[1.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
        color = [delz for i = 1:2]))
    else
        push!(layers, layer(x = [24,24], y = [-2000, 20000]./1000, Geom.line, Geom.point,
        Theme(alphas=[0.0],discrete_highlight_color=c->RGBA{Float32}(c.r,c.g,c.b,1), highlight_width=1Gadfly.pt),
        color = ["Autoconversion" for i = 1:2]))
    end


    guides = []
    push!(guides, Guide.xlabel("Droplet diameter (µm)"))
    push!(guides, Guide.ylabel("Height (km)"))
    push!(guides, Guide.title("Mean droplet diameter profile"))
    push!(guides, Guide.yticks(ticks=0:1:8))


    scales = []
    push!(scales, Scale.color_discrete_manual("black", "darkgoldenrod3","darkred","steelblue3"))

    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=40, ymin = 0, ymax = 8))
    p3 = plot(layers..., guides...,scales...,coords...)

    hstack(p2,p1,p3)
end

Td = HTML(string("<div style='color:#", hex(RGB(0.8,0,0)), "'>Dew-point temperature</div>"))
T0 = widget(["0", "5", "10", "15", "20"]; value = "5", label = "Temperature")
Tdew0 = widget(["-5", "0", "5", "10", "15"]; value = "0", label = Td)
C = slider(50:50:2000; value = 500, label = "C")
k = slider(0.1:0.1:1; value = 0.5, label = "k")
w = slider(1:1.0:10; value = 5, label = "w")
p1 = map((i,j,k,l,m)->cloud_app4(i,j,k,l,m), observe(T0), observe(Tdew0), observe(C), observe(k), observe(w))
display(p1)
x1 = hbox(pad(0.5em, Tdew0), pad(0.5em, T0))
display(hbox(vbox(x1)))
display(C)
display(k)
display(w)