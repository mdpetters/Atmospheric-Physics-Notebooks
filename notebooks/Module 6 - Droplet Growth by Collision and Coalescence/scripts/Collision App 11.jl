using AtmosphericThermodynamics, ParameterizedFunctions, DifferentialEquations, Gadfly, 
using CSV, Interpolations, Printf, Interact

dfA11 = CSV.read("figures/EcLangmuir.csv"; header=false)
RxA11 = convert(Array{Float64}, dfA11[2:end,1])
rxA11 = convert(Array{Float64}, Vector(dfA11[1,2:end]))
Ec11 = Matrix(dfA11[2:end,2:end])
EcCA11 = LinearInterpolation((RxA11,rxA11), Ec11)  # Ec(R,r)

ODEs = @ode_def_bare begin
    vR = vtp(2.0*R)
    E = EcCA11(R*1e6,r*1e6)
    f = c1*E*vR
    dz = (z >= -300.0) ? w - vR  : 0.0
    dR = ((z >= -300.0) & (f < 2.0*R)) ? f + c2/R : 0.0
end w c1 c2 r 

function bowen_model(r,LWC,w)
    Gadfly.set_default_plot_size(24Gadfly.cm, 9Gadfly.cm)
    T = 10.0 + 273.15
    p = 900.0*1e2
    s = w*0.1*1e-2  # In units of fractional supersaturation
    c1,c2 = LWC*1e-3/(4.0*rhow), G(T,p)*s

    prob = ODEProblem(ODEs,[0.0,1.261*r*1e-6],(0.0,7200.0),[w, c1, c2, r*1e-6])
    sol = solve(prob,AutoTsit5(Rosenbrock23()), alg_hints=[:stiff],abstol=1e-8,reltol=1e-8)
    ext = hcat(sol.u...)
    p1 = plot(x=sol.t./60.0, y = ext[1,:], Geom.line(preserve_order=true),
         Theme(default_color = "black"),
         Guide.xlabel("Time (min)"),
         Guide.ylabel("Height above cloud base (m)"),
         Guide.xticks(ticks = 0:20:120),
         Scale.y_continuous(labels = i->@sprintf("%i",i)),
         Scale.color_discrete_manual("black"),
         Coord.cartesian(xmin=0, xmax=120, ymin = 0))

    p2 = plot(x=2.0*ext[2,:].*1000.0, y = ext[1,:], Geom.line(preserve_order=true),
         Theme(default_color = "black"),
         Guide.xlabel("Droplet diameter (mm)"),
         Guide.ylabel("Height above cloud base (m)"),
         Guide.xticks(ticks = 0:0.5:3),
         Scale.y_continuous(labels = i->@sprintf("%i",i)),
         Scale.color_discrete_manual("black"),
         Coord.cartesian(xmin=0, xmax=3, ymin = 0))
    hstack(p1,p2)
end

LWCCA11 = togglebuttons([0.5, 0.75, 1.0, 1.5], value = 1.0, label = "LWC (g/kg)")
wCA11 = togglebuttons([0.2, 0.5, 1], value = 1.0, label = "w (m/s)")
rCA11 = togglebuttons([8.0, 10.0, 15.0, 20.0], value = 10.0, label = "r (μm)")
display(hbox(rCA11,LWCCA11,wCA11))
map(bowen_model, rCA11, LWCCA11, wCA11)