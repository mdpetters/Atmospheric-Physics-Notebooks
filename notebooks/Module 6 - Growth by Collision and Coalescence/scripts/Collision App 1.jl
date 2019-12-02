using Gadfly, Compose, Colors, Interact, AtmosphericThermodynamics

run = Observable(true)
set_default_graphic_size(10Compose.cm, 10Compose.cm)

function fps(f)
    run[] = false
    timer = Observable(0.0)
    run[] = true

    @async while run[]
        sleep(1.0./f)
        timer[] = timer[]+1.0/f
    end
    
    timer
end 

λ(T::Float64,p::Float64) = 6.6e-8*(101315.0/p)*(T/293.15)                             # Mean free path of air
η(T::Float64) = 1.83245e-5*exp(1.5*log(T/296.1))*(406.55)/(T+110.4)                   # viscosity of air
Cc(T::Float64,p::Float64,d::Float64) = 1.0+λ(T,p)/d*(2.34+1.05*exp.(-0.39*d/λ(T,p)))  # Slip correction
ρg(T::Float64,p::Float64) = p/(Rd*T)                                                  # Air density
Re(v::Float64,d::Float64,T::Float64,p::Float64) = ρg(T,p)*v*d/η(T)                    # Reynolds number
Cd(Re::Float64) = (Re < 0.1) ? 24.0/Re : 24.0/Re.*(1+0.15*Re^0.687)                   # Drag coefficient 

function vt(d::Float64;T=298.15,p=1e5,ρp=1e3)  
    vts1 = (d,v) -> (4.0*ρp*d*g*Cc(T,p,d)/(3.0*Cd(Re(v,d,T,p))*ρg(T,p)))^0.5
    vts2 = (d,v) -> (vts1(d,v)-v)^2.0 < 1e-30 ? v : vts2(d,vts1(d,v))
    vts2(d, 1e-5)
end

vtx(τ::Float64, d::Float64, t::Float64) = vt(d)*(1.0-exp(-t/τ))

function anim1(t)
    i = vc[]*t
    g1 = [[(y,0), (y,1)] for (x,y) in zip(zeros(11,1), 0:0.1:1)]
    g2 = [[(1,y-(i%0.1)), (x,y-(i%0.1))] for (x,y) in zip(zeros(11,1), 0:0.1:1)]

    z = 0.02 + (0.40-0.17)*vc[]/term
    compose(context(), line([g1;g2]), stroke("black"), linewidth(0.1Compose.mm),
       (context(),Compose.circle(0.5, 0+0.5, 0.1), fill("steelblue3"), stroke("white")),
       (context(), stroke("black"),arrow(), line([(0.5,0.6), (0.5, 0.85)]), line([(0.5,0.4), (0.5, 0.4-z)]), 
            linewidth(0.5Compose.mm)),
       (context(), text(0.53, 0.86, "F<sub>g</sub> = mg = π/6 D<sup>3</sup> ρ<sub>p</sub> g"),
            text(0.53, 0.38-z, "F<sub>drag</sub> = 1/2 ρ <sub>air</sub> v <sup>2</sup> C <sub>d</sub>"),
                  fill("black"), fontsize(10Compose.pt), stroke(RGBA(1,1,1,0))))
end

run[] = false
function runit()
    label = Observable("(time (s),velocity (m/s),fraction of vt (-))")
    timer = fps(5.0)
    
    T,p,ρp = 298.15,1e5,1000.0
    τ = ρp*dps^2.0*Cc(T,p,dps)/(18.0*η(T))
    
    global vc = map(t->vtx(τ,dps,t), timer)
    txt = map(i->(round(i,digits = 1),round(vc[],digits = 2),round(vc[]/term,digits = 2)), timer)
    img = map(anim1, timer) 

    display(img)
    display(label)
    display(txt)
end

vc = Observable(0.0)
dps = 800e-6
term = vt(dps)  

onoff = widget(false)
display(onoff)

function foo(r)
    if r == true
        IJulia.clear_output()
        display(onoff)
        runit()
    else
        run[] = false
    end
end
map(foo, onoff)
anim1(0)
