using Distributions, Gadfly, Interact, Printf, AtmosphericThermodynamics

oLWC = Observable("")

function condensation_app1(Nt,s,tmin)
    Gadfly.set_default_plot_size(25Gadfly.cm, 10Gadfly.cm)
    De = exp10.(range(log10(0.1e-6), stop=log10(200e-6), length=50))
    Dp = sqrt.(De[2:end].*De[1:end-1])
    ΔD = (De[2:end]-De[1:end-1])

    S = Nt*pdf.(Gamma(7,6e-7),Dp)

    t = tmin*60
    s = s/100.0
    N = S.*ΔD;

    G0 = 1e-11
    a = Dp./2.0
    Dp2 = 2.0*sqrt.(a.^2 .+ 2.0*G0*s*t)
    
    colors = ["black", "darkred"]
    xticks = log10.(collect([1:1:9;10:10:90;100]))
    xlabel = log10.([1,10,100])
    str = @sprintf("DSD after %03i min of growth", tmin)
    l1 = ["DSD near cloud base" for i=1:length(N)]
    l2 = [str for i=1:length(N)]
    
    p1 = plot(layer(x = Dp.*1e6, y = N, color = l1, Geom.step), 
         layer(x = Dp2.*1e6, y = N, color = l2, Geom.step),
         Guide.xlabel("Droplet diameter (μm)"),
         Guide.ylabel("Concentration (cm<sup>-3</sup>)"),
         Guide.xticks(ticks = xticks),
         Scale.x_log10(labels = x->ifelse(sum(x.==xlabel)==1,@sprintf("%i", exp10(x)), "")), 
         Scale.color_discrete_manual(colors...),
         Coord.cartesian(xmin=0, xmax=2))
    
    LWC = sum(pi/6.0*Dp2.^3*1000.0.*N)*1e9
    oLWC[] = @sprintf("Final LWC = %.2f g/m^3", LWC)
    p1
end

Nt = togglebuttons([50, 200, 700, 1000], value = 200, label = "Nt (cm-3)")
s = togglebuttons(collect([0.1, 0.5, 1]), value = 0.5, label = "s(%)")
t = slider(0:1.0:120, value = 2.0, label = "time (min)")
b1 = hbox(Interact.pad(0.5em, Nt), Interact.pad(0.5em, s))
display(hbox(b1, Interact.pad(0.5em,t)))
display(map((i,j,k)->condensation_app1(i,j,k), observe(Nt), observe(s), observe(t)))
display(widget(oLWC))
