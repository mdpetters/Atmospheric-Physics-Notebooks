using Gadfly, Compose, Colors, Interact,CSV, Printf,Interpolations
using AtmosphericThermodynamics

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]
LWC = Observable("0.0")

function collision_app10(i,T,p,r,NrCA10,s)
    Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)
    Tk = T + 273.15
    R = 10.0:2.0:40.0
    Rcond = 1.0:0.5:40.0

    Ecd = [0, 0.17, 0.37, 0.55]
    Rdd = [10.0, 20.0, 30.0, 40.0]
    itp = interpolate((Rdd,),Ecd,Gridded(Linear()))
    Ec = (i == 1) ? 1.0 : itp(R)

    Nr = NrCA10*1e6
    dRdt_cond = @. G(Tk,p*1e2)/(Rcond*1e-6)*1e9*s/100.0
    mLWC = Nr * 4.0/3.0 * π * (r*1e-6)^3.0 * 997.1
    LWC[] = @sprintf("LWC %.1f g/kg", mLWC .* 1000.0)
    dRdt = @. g/(18.0*η(Tk))*mLWC*Ec*(R*1e-6)^2.0
    l1 = ["Gravitational Collection" for i = 1:length(R)]
    l2 = ["Condensational Growth" for i = 1:length(Rcond)]

    lab = 0:10:40
    lfun = x->ifelse(sum(x .== lab) == 1, @sprintf("%i",x), "")

    plot(layer(x = R, y = dRdt*1e9, Geom.line, color = l1),
         layer(x = Rcond, y = dRdt_cond, Geom.line, color = l2),
         Guide.xticks(ticks = 0:5:40),
         Guide.yticks(ticks = 0:5:40),
         Scale.x_continuous(labels=lfun),
         Scale.y_continuous(labels=lfun),
        Guide.xlabel("Collector drop radius, R (μm)"),
        Guide.ylabel("Growth rate dR/dt (nm/s)"),
        Scale.color_discrete_manual("black", "darkred", "darkgoldenrod3"),
        Coord.cartesian(xmin = 0, xmax = 40,ymin = 0, ymax = 40))
end

TCA10 = slider(-20:1.0:20, value = 10.0, label = "Temperature (°C)")
pCA10 = slider(100:10:1000, value = 1000.0, label = "Pressure (hPa)")
rCA10 = slider(5:0.5:20, value = 10.0, label = "Cloud drop radius, r (μm)")
NrCA10 = slider(50:10.0:1000.0, value = 200.0, label = "Cloud drop number, Nr (# cm-3)")
sCA10 = slider(0.01:0.01:0.2, value = 0.1, label = "Supersaturation (%)")
valsCA10 = OrderedDict("Constant Collection Efficiency Ec = 1"=>1,"Radius-Dependent Collection Efficiency"=>2)
RCA10 = togglebuttons(valsCA10, value  = 2)
display(RCA10)
display(sCA10)
display(hbox(TCA10,pCA10))
display(hbox(NrCA10, rCA10))
display(LWC)
map(collision_app10, RCA10,TCA10,pCA10,rCA10,NrCA10,sCA10)