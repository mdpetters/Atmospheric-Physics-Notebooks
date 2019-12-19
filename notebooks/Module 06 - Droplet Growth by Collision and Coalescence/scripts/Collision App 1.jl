using Gadfly, Compose, Colors, Interact, AtmosphericThermodynamics

run = Observable(true)
timer = Observable(0.0)

function fps(f)
    run[] = false
    run[] = true

    @async while run[]
        sleep(1.0./f)
        timer[] = timer[]+1.0/f
    end
    
    timer
end 

vtx(τ::Float64, d::Float64, t::Float64) = vt(d)*(1.0-exp(-t/τ))

label1 = "F<sub>g</sub> = mg = π/6 D<sup>3</sup> ρ<sub>p</sub> g"
label2 = "F<sub>drag</sub> = π/8 C <sub>d</sub> ρ <sub>air</sub> D <sup>2</sup> v <sup>2</sup>"
function anim1(t)
    z = 0.02 + (0.40-0.17)*vc[]/term
    i = vc[]*t
    g1 = [[(y,0), (y,1)] for (x,y) in zip(zeros(11,1), 0:0.1:1)]
    g2 = [[(1,y-(i%0.1)), (x,y-(i%0.1))] for (x,y) in zip(zeros(11,1), 0:0.1:1)]

    compose(context(), line([g1;g2]), stroke("black"), linewidth(0.1Compose.mm),
       (context(),Compose.circle(0.5, 0+0.5, 0.1), fill("steelblue3"), stroke("white")),
       (context(), stroke("black"), arrow(), linewidth(0.5Compose.mm),
            line([(0.5,0.6), (0.5, 0.85)]), line([(0.5,0.4), (0.5, 0.4-z)])), 
       (context(), text(0.53, 0.86, label1), text(0.53, 0.38-z, label2),
            fill("black"), fontsize(10Compose.pt), stroke(RGBA(1,1,1,0))))
end

run[] = false
label = Observable("(time (s),velocity (m/s),fraction of vt (-))")

vc = Observable(0.0)
txt = Observable((0.0,0.0,0.0))
dps = 800e-6
Tx,px,ρpx = 298.15,1e5,1000.0
τ = ρpx*dps^2.0*Cc(Tx,px,dps)/(18.0*η(Tx))
term = vt(dps)  

onoff = widget(false)

function collision_app1(r)
    set_default_graphic_size(10Compose.cm, 10Compose.cm)

    if r == true
        global timer = fps(5.0)
    else
        run[] = false
        global timer[] = 0.0
    end
end

map(collision_app1, onoff)
vc = map(t->vtx(τ,dps,t), timer)
b = map(i->(round(i,digits = 1),round(vc[],digits = 2),round(vc[]/term,digits = 2)), timer)
c = map(anim1, timer) 

display(onoff)
display(label)
display(b)
display(c)