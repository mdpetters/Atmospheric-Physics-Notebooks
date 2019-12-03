using Gadfly, Compose, Colors, Interact, AtmosphericThermodynamics

run = Observable(true)
timer = Observable(0.0)

# function fps(f)
#     run[] = false
#     run[] = true

#     @async while run[]
#         sleep(1.0./f)
#         timer[] = timer[]+1.0/f
#     end
    
#     timer
# end 

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

function anim2(R,r,y)
    set_default_graphic_size(20Compose.cm, 20Compose.cm)
    n = 150.0
#    i = vc[]*t
    # g1 = [[(y,0), (y,1)] for (x,y) in zip(zeros(11,1), 0:0.1:1)]
    # g2 = [[(1,y-(i%0.1)), (x,y-(i%0.1))] for (x,y) in zip(zeros(11,1), 0:0.1:1)]

#    z = 0.02 + (0.40-0.17)*vc[]/term
    z = 0.0
    x1 = 0.3
    x2 = x1 + y/n
    z1 = 0.15
    z2 = 0.45
    compose(context(),
      (context(), stroke("black"), linewidth(0.25Compose.mm), strokedash([3Compose.mm,1Compose.mm]),
          line([(x1,z1-R/n-0.4*R/n), (x1, 1)]),
          line([(x2,z2-r/n-0.4*r/n), (x2, 1)])),
      (context(), stroke("black"),arrow(), linewidth(0.25Compose.mm),
          line([(x1,z1), (x1+R/n-0.012,z1)]), 
          line([(x2,z2), (x2-r/n+0.012,z2)]),
          line([(x1+y/n/2,0.9), (x1+y/n-0.012,0.9)]),
          line([(x1+y/n/2,0.9), (x1+0.012,0.9)])),
      (context(), fill("black"), fontsize(10Compose.pt), stroke(RGBA(1,1,1,0)),
          text(x1+R/n/4, z1-0.008, "R"),
          text(x2-r/n/2.5, z2-0.008, "r"),
          text(x1+y/n/2-0.008, 0.89, "y")),

       (context(), Compose.circle(x1, z1, R/n), fill("steelblue3"), stroke("white")),
       (context(),Compose.circle(x2, z2, r/n), fill("darkgoldenrod3"), stroke("white")))
end

anim2(20.0,5.0,22.0)


# run[] = false
# label = Observable("(time (s),velocity (m/s),fraction of vt (-))")

# vc = Observable(0.0)
# txt = Observable((0.0,0.0,0.0))
# dps = 800e-6
# Tx,px,ρpx = 298.15,1e5,1000.0
# τ = ρpx*dps^2.0*Cc(Tx,px,dps)/(18.0*η(Tx))
# term = vt(dps)  

# onoff = widget(false)

# function collision_app1(r)
#     set_default_graphic_size(10Compose.cm, 10Compose.cm)

#     if r == true
#         global timer = fps(5.0)
#     else
#         run[] = false
#         global timer[] = 0.0
#     end
# end

# map(collision_app1, onoff)
# vc = map(t->vtx(τ,dps,t), timer)
# b = map(i->(round(i,digits = 1),round(vc[],digits = 2),round(vc[]/term,digits = 2)), timer)
# c = map(anim1, timer) 

# display(onoff)
# display(label)
# display(b)
# display(c)


