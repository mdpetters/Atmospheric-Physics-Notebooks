using Gadfly, Printf, DataFrames, Dates, CSV, Colors, LsqFit, Interact

hfdma = CSV.read("scripts/hfdma.csv")
lhfdma = CSV.read("scripts/lhfdma.csv")
uhfdma = CSV.read("scripts/uhfdma.csv")
rdma = CSV.read("scripts/rdma.csv")
lrdma = CSV.read("scripts/lrdma.csv")
urdma = CSV.read("scripts/urdma.csv")
pops = CSV.read("scripts/pops.csv")
lpops = CSV.read("scripts/lpops.csv")
upops = CSV.read("scripts/upops.csv")

Dhf = convert(Vector, hfdma[1,2:end])
Shf = convert(Matrix, hfdma[2:end,2:end])
Slhf = convert(Matrix, lhfdma[2:end,2:end])
Suhf = convert(Matrix, uhfdma[2:end,2:end])
Drd = convert(Vector, rdma[1,2:end])
Srd = convert(Matrix, rdma[2:end,2:end])
Slrd = convert(Matrix, lrdma[2:end,2:end])
Surd = convert(Matrix, urdma[2:end,2:end])
t = collect(skipmissing(hfdma[2:end,1]))
Dpo = convert(Vector, pops[1,2:end])
Spo = convert(Matrix, pops[2:end,2:end])
Slpo = convert(Matrix, lpops[2:end,2:end])
Supo = convert(Matrix, upops[2:end,2:end])


gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function aerosol_app3(j,Nt1,Dg1,σg1,Nt2,Dg2,σg2, Nt3,Dg3,σg3,Nt4,Dg4,σg4)
        Gadfly.set_default_plot_size(20Gadfly.cm, 18Gadfly.cm)

        𝕗 = lognormal([[Nt1, Dg1, σg1],[Nt2, Dg2, σg2],[Nt3, Dg3, σg3],[Nt4, Dg4, σg4]]; 
                       d1 = 1.0, d2 = 4000.0, bins = 500); 

                       colors = ["darkgoldenrod3", "darkred", "steelblue3", "black"]
        xlabel = log10.([5, 10, 20, 50, 100, 200, 500, 1000, 2000])
        lfunx = x->ifelse(sum(x .== xlabel) == 1, @sprintf("%i",exp10(x)), "")

        l0 = layer(x=Dhf, y = Shf[j,:], ymin=Slhf[j,:], ymax=Suhf[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS2" for i=1:length(Dhf)], Theme(alphas=[0.2],lowlight_color=cfun))
        l1 = layer(x=Drd, y = Srd[j,:], ymin=Slrd[j,:], ymax=Surd[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS1" for i=1:length(Drd)], Theme(alphas=[0.2],lowlight_color=cfun))
        l2 = layer(x=Dpo, y = Spo[j,:], ymin=Slpo[j,:], ymax=Supo[j,:], Geom.line, Geom.ribbon,
                color = ["OPC" for i=1:length(Dpo)], Theme(alphas=[0.2],lowlight_color=cfun))
        l3 = layer(x = 𝕗.Dp, y = 𝕗.S, color = ["Model" for i = 1:500], Geom.line)
        p1 = plot(l1, l0, l2, l3,
                Guide.xlabel("Particle diameter (nm)"),
                Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
                Guide.title("Composite Size Distribtion $(t[j])"),
                Scale.color_discrete_manual(colors...),
                Guide.xticks(ticks = log10.(gengrid([1,10,100,1000]))),
                Scale.x_log10(labels = lfunx),
                Coord.cartesian(xmin=log10(4), xmax=log10(3000)))

        
        f = π.*(Dhf*1e-3).^2.0
        l0 = layer(x=Dhf, y = f.*Shf[j,:], ymin=f.*Slhf[j,:], ymax=f.*Suhf[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS2" for i=1:length(Dhf)], Theme(alphas=[0.2],lowlight_color=cfun))
        f = π.*(Drd*1e-3).^2.0
        l1 = layer(x=Drd, y = f.*Srd[j,:], ymin=f.*Slrd[j,:], ymax=f.*Surd[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS1" for i=1:length(Drd)], Theme(alphas=[0.2],lowlight_color=cfun))
        f = π.*(Dpo*1e-3).^2.0
        l2 = layer(x=Dpo, y = f.*Spo[j,:], ymin=f.*Slpo[j,:], ymax=f.*Supo[j,:], Geom.line, Geom.ribbon,
                color = ["OPC" for i=1:length(Dpo)], Theme(alphas=[0.2],lowlight_color=cfun))
        l3 = layer(x = 𝕗.Dp, y = 𝕗.S.*(𝕗.Dp*1e-3).^2.0.*π, color = ["Model" for i = 1:500], Geom.line)
        p2 = plot(l1, l0, l2, l3,
                Guide.xlabel("Particle diameter (nm)"),
                Guide.ylabel("dS/dlnD (μm<sup>2</sup> cm <sup>-3</sup>)"),
                Guide.title("Composite Size Distribtion $(t[j])"),
                Scale.color_discrete_manual(colors...),
                Guide.xticks(ticks = log10.(gengrid([1,10,100,1000]))),
                Scale.x_log10(labels = lfunx),
                Coord.cartesian(xmin=log10(4), xmax=log10(3000)))


        f = π.*(Dhf*1e-3).^3.0/6.0
        l0 = layer(x=Dhf, y = f.*Shf[j,:], ymin=f.*Slhf[j,:], ymax=f.*Suhf[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS2" for i=1:length(Dhf)], Theme(alphas=[0.2],lowlight_color=cfun))
        f = π.*(Drd*1e-3).^3.0/6.0
        l1 = layer(x=Drd, y = f.*Srd[j,:], ymin=f.*Slrd[j,:], ymax=f.*Surd[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS1" for i=1:length(Drd)], Theme(alphas=[0.2],lowlight_color=cfun))
        f = π.*(Dpo*1e-3).^3.0/6.0
        l2 = layer(x=Dpo, y = f.*Spo[j,:], ymin=f.*Slpo[j,:], ymax=f.*Supo[j,:], Geom.line, Geom.ribbon,
                color = ["OPC" for i=1:length(Dpo)], Theme(alphas=[0.2],lowlight_color=cfun))
        f = π.*(𝕗.Dp*1e-3).^3.0/6.0
        l3 = layer(x = 𝕗.Dp, y = f.*𝕗.S, color = ["Model" for i = 1:500], Geom.line)
        p3 = plot(l1, l0, l2, l3,
                Guide.xlabel("Particle diameter (nm)"),
                Guide.ylabel("dV/dlnD (μm<sup>3</sup> cm <sup>-3</sup>)"),
                Guide.title("Composite Size Distribtion $(t[j])"),
                Scale.color_discrete_manual(colors...),
                Guide.xticks(ticks = log10.(gengrid([1,10,100,1000]))),
                Scale.x_log10(labels = lfunx),
                Coord.cartesian(xmin=log10(4), xmax=log10(3000)))

        𝕗 = lognormal([[Nt1[], Dg1[], σg1[]],[Nt2[], Dg2[], σg2[]],
                      [Nt3[], Dg3[], σg3[]],[Nt4[], Dg4[], σg4[]]];
                       d1 = 1.0, d2 = 2500.0, bins = 500); 
        f = π.*(𝕗.Dp*1e-3).^3.0/6.0
        pm[] = round(sum(f.*𝕗.N.*2), digits = 1)

        vstack(p1,p2,p3)
end

str = Observable("PM 2.5 calculated from fit in μg m-3")    
pm = Observable(2.0)

display(time)
display(hbox(b1, pad(0.5em,σg1)))
display(hbox(b2, pad(0.5em,σg2)))
display(hbox(b3, pad(0.5em,σg3)))
display(hbox(b4, pad(0.5em,σg4)))
display(map((j,Nt1,Dg1,σg1,Nt2,Dg2,σg2,Nt3,Dg3,σg3,Nt4,Dg4,σg4) -> 
        aerosol_app3(j,Nt1,Dg1,σg1,Nt2,Dg2,σg2,Nt3,Dg3,σg3,Nt4,Dg4,σg4), 
        observe(time),
        throttle(dt, observe(Nt1)), throttle(dt, observe(Dg1)), throttle(dt, observe(σg1)),
        throttle(dt, observe(Nt2)), throttle(dt, observe(Dg2)), throttle(dt, observe(σg2)),
        throttle(dt, observe(Nt3)), throttle(dt, observe(Dg3)), throttle(dt, observe(σg3)),
        throttle(dt, observe(Nt4)), throttle(dt, observe(Dg4)), throttle(dt, observe(σg4))))
display(str)
display(pm)