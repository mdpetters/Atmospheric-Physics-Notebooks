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


function fitit(n,m)
        md = (A,x) -> @. A[1]/(√(2π)*log(A[3]))*exp(-(log(x/A[2]))^2/(2log(A[3])^2))
        logn = (A,x) -> mapreduce((A) -> md(A,x), +, A)
        model(x,p) = logn(map(i->[p[i],p[i+1],p[i+2]], 1:3:length(p)),x)
        p = vcat(eval.(Meta.parse.([map(i->"[Nt$i[],Dg$i[],σg$i[]]",1:n)...]))...)
        
        Dp1 = convert(Array{Float64},Drd)
        N1 = convert(Array{Float64},Srd[time[],:])
        Dp2 = convert(Array{Float64},Dhf)
        N2 = convert(Array{Float64},Shf[time[],:])
        Dp3 = convert(Array{Float64},Dpo)
        N3 = convert(Array{Float64},Spo[time[],:])
        
        fit = try 
            curve_fit(model, vcat(Dp1,Dp2,Dp3), vcat(N1,N2,N3), p)  
        catch end
        Ax = try 
            fit.param
        catch; p; end
    
        if (m > 0 ) 
            grr = map(1:n) do i
                str = @sprintf("Nt=%i,Dg=%.1f,σg=%.2f / ", Ax[(i-1)*3+1],Ax[(i-1)*3+2],Ax[(i-1)*3+3])
                "Mode $i: "*str
            end 
            Solution[] = reduce(*,grr)
        end
    end
    

function aerosol_app2(j,Nt1,Dg1,σg1,Nt2,Dg2,σg2, Nt3,Dg3,σg3,Nt4,Dg4,σg4)
        Gadfly.set_default_plot_size(20Gadfly.cm, 8Gadfly.cm)

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
end

dt = 1.0
time = slider(1:49, value = 20, label = "Time Index")
Nt1 = spinbox(0:10.0:10000, value = 0.0, label = "Mode 1: Nt,1 (cm-3)")
Dg1 = spinbox(1:0.1:20.0, value = 7.0, label = "Dg,1 (nm)")
σg1 = spinbox(1.1:0.01:2, value = 1.3, label = "σg,1 (-)")
b1 = hbox(pad(0.5em, Nt1), pad(0.5em, Dg1))


Nt2 = spinbox(0:10.0:10000, value = 0.0, label = "Mode 2: Nt,2 (cm-3)")
Dg2 = spinbox(10:1:100.0, value = 30.0, label = "Dg,2 (nm)")
σg2 = spinbox(1.1:0.01:2, value = 1.3, label = "σg,2 (-)")
b2 = hbox(pad(0.5em, Nt2), pad(0.5em, Dg2))

Nt3 = spinbox(0:10.0:10000, value = 0.0, label = "Mode 3: Nt,3 (cm-3)")
Dg3 = spinbox(80:1:300.0, value = 100.0, label = "Dg,3 (nm)")
σg3 = spinbox(1.1:0.01:2, value = 1.3, label = "σg,3 (-)")
b3 = hbox(pad(0.5em, Nt3), pad(0.5em, Dg3))

Nt4 = spinbox(0:0.01:5, value = 0.0, label = "Mode 4: Nt,4 (cm-3)")
Dg4 = spinbox(800:10:2000.0, value = 2000.0, label = "Dg,4 (nm)")
σg4 = spinbox(1.1:0.01:2, value = 1.3, label = "σg,4 (-)")
b4 = hbox(pad(0.5em, Nt4), pad(0.5em, Dg4))

Solution = Observable("")
on_mode = button("Fit one mode"; value=0)
tw_mode = button("Fit two modes"; value=0)
th_mode = button("Fit three modes"; value=0)
fo_mode = button("Fit four modes"; value=0)

map(m->fitit(1,m),observe(on_mode))
map(m->fitit(2,m),observe(tw_mode))
map(m->fitit(3,m),observe(th_mode))
map(m->fitit(4,m),observe(fo_mode))

display(time)
display(hbox(b1, pad(0.5em,σg1)))
display(hbox(b2, pad(0.5em,σg2)))
display(hbox(b3, pad(0.5em,σg3)))
display(hbox(b4, pad(0.5em,σg4)))

display(hbox(hbox(pad(1em,on_mode),pad(1em,tw_mode)),hbox(pad(1em,th_mode),pad(1em,fo_mode))))

display(map((j,Nt1,Dg1,σg1,Nt2,Dg2,σg2,Nt3,Dg3,σg3,Nt4,Dg4,σg4) -> 
        aerosol_app2(j,Nt1,Dg1,σg1,Nt2,Dg2,σg2,Nt3,Dg3,σg3,Nt4,Dg4,σg4), 
        observe(time),
        throttle(dt, observe(Nt1)), throttle(dt, observe(Dg1)), throttle(dt, observe(σg1)),
        throttle(dt, observe(Nt2)), throttle(dt, observe(Dg2)), throttle(dt, observe(σg2)),
        throttle(dt, observe(Nt3)), throttle(dt, observe(Dg3)), throttle(dt, observe(σg3)),
        throttle(dt, observe(Nt4)), throttle(dt, observe(Dg4)), throttle(dt, observe(σg4))))

display(Solution)