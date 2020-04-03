using Gadfly, CSV

import AtmosphericThermodynamics

df1 = CSV.read("figures/Andreae Blue Ocean.txt")
df1[!,:Regime] = ["Blue Ocean" for i = 1:length(df1[!,:D])]
df1[!,:Sample] = ["1" for i = 1:length(df1[!,:D])]

df2 = CSV.read("figures/Andreae Green Ocean 1.txt")
df2[!,:Regime] = ["Green Ocean 1" for i = 1:length(df2[!,:D])]
df2[!,:Sample] = ["1" for i = 1:length(df2[!,:D])]

df3 = CSV.read("figures/Andreae Green Ocean 2.txt")
df3[!,:Regime] = ["Green Ocean 2" for i = 1:length(df3[!,:D])]
df3[!,:Sample] = ["2" for i = 1:length(df3[!,:D])]

df4 = CSV.read("figures/Andreae Thai.txt")
df4[!,:Regime] = ["Thailand" for i = 1:length(df3[!,:D])]
df4[!,:Sample] = ["1" for i = 1:length(df3[!,:D])]

df = [df1;df2;df3;df4]

function cloud_app5(i,k,l,m)
    Gadfly.set_default_plot_size(13Gadfly.cm, 11Gadfly.cm)

    TLCL = parse(Float64,i)
    zLCL = 1000.0
    C = k
    k = l
    w0 = m

    Rd = 287.5
    rhow = 997.1
    BETA = beta(k/2.0,1.5)
    Nd0 = @. C^(2/(k+2)) * ( (1.6e-3*(w0.*100.0)^1.5) / (k*BETA) ) ^ (k/(k+2.0))
    Δz = 10.0:10.0:8000.0

    wl = AtmosphericThermodynamics.wl.(TLCL+273.15, zLCL, Δz)
    p = @. 1e5*exp(-(zLCL + Δz)/8000.0)
    Tk = TLCL.+273.15
    rhoa = @. p/(Rd*Tk)
    LWC = @. wl.*rhoa./1e6./rhow  # m3 water cm-3 air
    Dm = @. (LWC*6.0/(π*Nd0))^(1/3.0)*1e6  # in micron
    LWC2 = @. wl./rhow  # m3 water kg-1 air
    Nd2 = @. Nd0.*1e6/rhoa[1] # CDNC kg-1 air
    Dm = @. (LWC2*6/(π*Nd2))^(1/3.0)*1e6


    layers = []
    push!(layers, layer(x = df[!,:D], y=df[!,:z]./1000, color = df[!,:Regime], Geom.line, Geom.point))
    push!(layers, layer(x = [24,24], y=[0, 10], color = ["Autoconversion Threshold" for i = 1:2], Geom.line))
    push!(layers, layer(x = Dm, y=Δz./1000, color = ["Model" for i = 1:length(Δz)], 
                        Geom.line(preserve_order=true), Gadfly.style(line_width=2Gadfly.pt, line_style = [:dash])))
    
    guides = []
    push!(guides, Guide.xlabel("Modal drop diameter (µm)"))
    push!(guides, Guide.ylabel("Height above cloud base (km)"))
    push!(guides, Guide.xticks(ticks=0:5:40))
    push!(guides, Guide.yticks(ticks=0:1:8))


    scales = []
    push!(scales, Scale.color_discrete_manual("steelblue3", "mediumseagreen", "darkgreen", "darkgoldenrod3", "darkred", "black"))
    
    coords = []    
    push!(coords,Coord.cartesian(xmin=0, xmax=40, ymin = 0, ymax = 8))
    p1 = plot(layers..., guides...,scales...,coords...)
end

T0 = widget(["-15", "-10","-5","0", "5", "10", "15"]; value = "5", label = "Temperature @ LCL (°C)")
#zLCL = widget(["1", "2","3","4", "5"]; value = "1", label = "Height @ LCL (km)")
C = slider(50:50:6000; value = 1000, label = "C")
k = slider(0.1:0.1:1; value = 0.7, label = "k")
w = slider(1:1.0:10; value = 2, label = "w")
p1 = map((i,k,l,m)->cloud_app5(i,k,l,m), observe(T0), observe(C), observe(k), observe(w))
display(p1)
x1 = hbox(pad(0.5em, T0))
display(hbox(vbox(x1)))
display(C)
display(k)
display(w)