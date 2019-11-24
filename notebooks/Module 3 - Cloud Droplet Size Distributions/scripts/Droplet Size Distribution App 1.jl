using Distributions, Interact, Gadfly, Colors, Printf

function dsd(Dn,Nt,v)
    De = exp10.(range(log10(0.1e-6), stop=log10(500e-6),length=50))
    Dp = sqrt.(De[2:end].*De[1:end-1])
    ΔD = (De[2:end]-De[1:end-1])
    N = Nt*pdf.(Gamma(v,Dn),Dp).*ΔD

    plot(x = Dp,y=N,Geom.step,Guide.ylabel("Droplet Concentration (cm<sup>-3</sup>)"),
         Guide.xlabel("Droplet diameter (μm)"), Theme(default_color="black", alphas=[0.1]), 
         Scale.x_log10())
end

Dn = togglebuttons(label = "Dn (μm)", OrderedDict("1×10⁻⁷"=>1e-7, "5×10⁻⁷"=>5e-7, "1×10⁻⁶"=>1e-6, "5×10⁻⁶"=>5e-6, "1×10⁻⁵"=>1e-5))
Nt = togglebuttons(label = "Nt (cm-3)", OrderedDict("10"=>10.0, "100"=>100.0, "1000"=>1000.0))
v = slider(1:1.0:20, value = 3.0, label = "v (-)")
display(map((i,j,k)->dsd(i,j,k), observe(Dn), observe(Nt), observe(v)))
display(hbox(hbox(pad(0.5em, Dn), pad(0.5em, Nt))))
display(v)