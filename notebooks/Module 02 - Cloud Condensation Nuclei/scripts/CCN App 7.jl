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
        N1 = convert(Array{Float64},Srd[49,:])
        Dp2 = convert(Array{Float64},Dhf)
        N2 = convert(Array{Float64},Shf[49,:])
        Dp3 = convert(Array{Float64},Dpo)
        N3 = convert(Array{Float64},Spo[49,:])
        
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
    

function aerosol_app2(j,Nt1,Dg1,σg1,Nt2,Dg2,σg2, Nt3,Dg3,σg3,Nt4,Dg4,σg4,κ)
        Gadfly.set_default_plot_size(24Gadfly.cm, 9Gadfly.cm)

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

        s = exp10.(range(log10(0.08), stop = log10(2), length = 100))
        
        function mAS(Nt, Dg, σg, κ)
            ψ(s) = (4.0/27.0)^(1.0/3.0)*A/(κ^(1.0/3.0)*Dg.*1e-9*log(s/100.0+1.0)^(2.0/3.0))
            Af(s) =  Nt*1/2*erfc(log.(ψ.(s))/(sqrt(2.0)*log(σg)))
            Af.(s)
        end
        N = mAS(Nt1,Dg1,σg1,κ) + mAS(Nt2,Dg2,σg2,κ) + mAS(Nt3,Dg3,σg3,κ) + mAS(Nt4,Dg4,σg4,κ)

        df = DataFrame(s = s, y = N, col = ["Nccn" for i = 1:length(s)])
        xticks = log10.([0.08;0.09;collect(0.1:0.1:1);2])
        xtlabel = [0.1, 1]
        ytlabel = [1, 10, 100, 1000,10000]
        yticks = log10.([1:1:10;20:10:100;200:100:1000;2000:1000:10000])
    
        lfunx = x->ifelse(sum(exp10.(x) .== xtlabel) == 1, @sprintf("%.1f", exp10(x)), "")
        lfuny = x->ifelse(sum(exp10.(x) .== ytlabel) == 1, @sprintf("%i", exp10(x)), "")
    
        layers = []
        push!(layers,layer(x=df[!,:s], y = df[!,:y], color = df[!,:col], Geom.line))
    
        guides = []
        push!(guides, Guide.xlabel("Supersaturation (%)"))
        push!(guides, Guide.ylabel("Number concentration (cm<sup>-3</sup>)"))
        push!(guides, Guide.title("Cumulative CCN spectrum"))

        push!(guides, Guide.xticks(ticks=xticks))
        push!(guides, Guide.yticks(ticks=yticks))
    
        scales = []
        push!(scales, Scale.x_log10(labels = lfunx))
        push!(scales, Scale.y_log10(labels = lfuny))
        push!(scales, Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3", "steelblue3"))
    
        coords = []
        push!(coords,Coord.cartesian(xmin=log10(0.08), xmax=log10(2), ymin = log10(80), ymax = log10(10000)))
    
        p2 = plot(layers...,  guides..., scales..., coords...)   

        hstack(p1,p2)
            
end

#Nt=3698,Dg=56.5,σg=1.37 / Mode 2: Nt=6066,Dg=36.3,σg=1.89 / Mode 3: Nt=260,Dg=162.7,σg=1.27 / "

Nt1 = spinbox(0:10.0:10000, value = 6066.0, label = "Mode 1: Nt,1 (cm-3)")
Dg1 = spinbox(1:0.1:20.0, value = 36.3, label = "Dg,1 (nm)")
σg1 = spinbox(1.1:0.01:2, value = 1.89, label = "σg,1 (-)")
b1 = hbox(pad(0.5em, Nt1), pad(0.5em, Dg1))


Nt2 = spinbox(0:10.0:10000, value = 3698, label = "Mode 2: Nt,2 (cm-3)")
Dg2 = spinbox(10:1:100.0, value = 56.5, label = "Dg,2 (nm)")
σg2 = spinbox(1.1:0.01:2, value = 1.37, label = "σg,2 (-)")
b2 = hbox(pad(0.5em, Nt2), pad(0.5em, Dg2))

Nt3 = spinbox(0:10.0:10000, value = 260.0, label = "Mode 3: Nt,3 (cm-3)")
Dg3 = spinbox(80:1:300.0, value = 162.7, label = "Dg,3 (nm)")
σg3 = spinbox(1.1:0.01:2, value = 1.27, label = "σg,3 (-)")
b3 = hbox(pad(0.5em, Nt3), pad(0.5em, Dg3))

Nt4 = spinbox(0:0.01:5, value = 1.8, label = "Mode 4: Nt,4 (cm-3)")
Dg4 = spinbox(800:10:2000.0, value = 2000.0, label = "Dg,4 (nm)")
σg4 = spinbox(1.1:0.01:2, value = 2.1, label = "σg,4 (-)")
b4 = hbox(pad(0.5em, Nt4), pad(0.5em, Dg4))

display(hbox(b1, pad(0.5em,σg1)))
display(hbox(b2, pad(0.5em,σg2)))
display(hbox(b3, pad(0.5em,σg3)))
display(hbox(b4, pad(0.5em,σg4)))

κs = [0;0.01:0.01:1;1.1;1.2;1.3]
κ7 = slider(κs; value = 0.4, label = "Hygroscopicity (-)", throttle=1.0)
display(κ7)

dt = 1.0
display(map((Nt1,Dg1,σg1,Nt2,Dg2,σg2,Nt3,Dg3,σg3,Nt4,Dg4,σg4,κ) -> 
        aerosol_app2(49,Nt1,Dg1,σg1,Nt2,Dg2,σg2,Nt3,Dg3,σg3,Nt4,Dg4,σg4,κ), 
        throttle(dt, observe(Nt1)), throttle(dt, observe(Dg1)), throttle(dt, observe(σg1)),
        throttle(dt, observe(Nt2)), throttle(dt, observe(Dg2)), throttle(dt, observe(σg2)),
        throttle(dt, observe(Nt3)), throttle(dt, observe(Dg3)), throttle(dt, observe(σg3)),
        throttle(dt, observe(Nt4)), throttle(dt, observe(Dg4)), throttle(dt, observe(σg4)),
        throttle(dt, observe(κ7))))
