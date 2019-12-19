using Gadfly, Printf, DataFrames, Dates, CSV, Colors

hfdma = CSV.read("scripts/hfdma.csv")
lhfdma = CSV.read("scripts/lhfdma.csv")
uhfdma = CSV.read("scripts/uhfdma.csv")
rdma = CSV.read("scripts/rdma.csv")
lrdma = CSV.read("scripts/lrdma.csv")
urdma = CSV.read("scripts/urdma.csv")
pops = CSV.read("scripts/pops.csv")
lpops = CSV.read("scripts/lpops.csv")
upops = CSV.read("scripts/upops.csv")

gengrid(r) = [vcat(map(x->x:x:9x,r)...);r[end]*10]
cfun(c) = RGBA{Float32}(c.r,c.g,c.b,1)

function aerosol_app2(j)
        Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)

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

        colors = ["darkgoldenrod3", "darkred", "steelblue3", "darkgrey"]
        xlabel = log10.([5, 10, 20, 50, 100, 200, 500, 1000, 2000])
        lfunx = x->ifelse(sum(x .== xlabel) == 1, @sprintf("%i",exp10(x)), "")

        #l0 = layer(x=𝕗.Dp, y = 𝕗.S, color = ["Lognormal function" for i=1:1000], Geom.line)
        l0 = layer(x=Dhf, y = Shf[j,:], ymin=Slhf[j,:], ymax=Suhf[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS2" for i=1:length(Dhf)], Theme(alphas=[0.2],lowlight_color=cfun))
        l1 = layer(x=Drd, y = Srd[j,:], ymin=Slrd[j,:], ymax=Surd[j,:], Geom.line, Geom.ribbon,
                color = ["SMPS1" for i=1:length(Drd)], Theme(alphas=[0.2],lowlight_color=cfun))
        l2 = layer(x=Dpo, y = Spo[j,:], ymin=Slpo[j,:], ymax=Supo[j,:], Geom.line, Geom.ribbon,
                color = ["OPC" for i=1:length(Dpo)], Theme(alphas=[0.2],lowlight_color=cfun))
        p1 = plot(l1,l0, l2,
                Guide.xlabel("Particle diameter (nm)"),
                Guide.ylabel("dN/dlnD (cm <sup>-3</sup>)"),
                Guide.title("Composite Size Distribtion $(t[j])"),
                Scale.color_discrete_manual(colors...),
                Guide.xticks(ticks = log10.(gengrid([1,10,100,1000]))),
                Scale.x_log10(labels = lfunx),
                #Scale.y_log10(),
                #Coord.cartesian(xmin=log10(4), xmax=log10(5000),ymin = -2))
                Coord.cartesian(xmin=log10(4), xmax=log10(3000)))
end

time = slider(1:49, value = 18, label = "Time Index")
display(time)
display(map(j->aerosol_app2(j), observe(time)))