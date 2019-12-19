using Gadfly, Compose, Colors, Interact, AtmosphericThermodynamics

runA7 = Observable(true)
timerA7 = Observable(0.1)

function fpsA7(f)
    runA7[] = false
    runA7[] = true

    @async while runA7[]
        sleep(1.0./f)
        timerA7[] = timerA7[]+1.0/f
    end
    
    timerA7
end 

function anim2(R,r,y,z,t)
    set_default_graphic_size(20Compose.cm, 20Compose.cm)
    n = 150.0

    x1 = 0.35
    x2 = x1 + y/n
    vt1 = vt(2*R*1e-6)./vt(50e-6)
    vt2 = vt(2*r*1e-6)./vt(50e-6)
    z1 = 0.14 + t*vt1*0.02
    z2 = 0.14 + z/n + t*vt2*0.02
    vt1 = vt(2*R*1e-6)./vt(50e-6)
    vt2 = vt(2*r*1e-6)./vt(50e-6)

    if sqrt((x1 - x2)^2.0 + (z1 - z2)^2.0) < (R/n + r/n)
        rn = (R^3+r^3)^(0.333)
        compose(context(),
        (context(), stroke("black"), linewidth(0.15Compose.mm), strokedash([3Compose.mm,1Compose.mm]),
            line([(x1,z1-rn/n-0.4*rn/n), (x1, 1)])),
        (context(), stroke("black"), arrow(), linewidth(0.25Compose.mm),
            line([(x1,z1), (x1+rn/n-0.012,z1)])), 
        (context(), stroke("black"), arrow(), linewidth(0.25Compose.mm),
            line([(x1,z1+rn/n), (x1, z1+rn/n+0.2*vt1)])), 
        (context(), fill("black"), fontsize(10Compose.pt), stroke(RGBA(1,1,1,0)),
            text(x1+R/n/4, z1-0.008, "(R<sup>3</sup>+r<sup>3</sup>)<sup>1/3</sup>"),
            text(x1-0.04, z1+R/n+0.2*vt1, "v<sub>t</sub>")), 
         (context(), Compose.circle(x1,z1,rn/n),fill("steelblue3"), stroke("white")))
    else
        compose(context(),
        (context(), stroke("black"), linewidth(0.15Compose.mm), strokedash([3Compose.mm,1Compose.mm]),
            line([(x1,z1-R/n-0.4*R/n), (x1, 1)]),
            line([(x2,z2-r/n-0.4*r/n), (x2, 1)])),
        (context(), stroke("black"), arrow(), linewidth(0.25Compose.mm),
            line([(x1,z1), (x1+R/n-0.012,z1)]), 
            line([(x2,z2), (x2-r/n+0.012,z2)]),
            line([(x1+y/n/2,0.9), (x1+y/n-0.012,0.9)]),
            line([(x1+y/n/2,0.9), (x1+0.012,0.9)])),
         (context(), stroke("black"), arrow(), linewidth(0.25Compose.mm),
            line([(x1,z1+R/n), (x1, z1+R/n+0.2*vt1)]), 
            line([(x2,z2+r/n), (x2, z2+r/n+0.2*vt2)])), 
        (context(), fill("black"), fontsize(10Compose.pt), stroke(RGBA(1,1,1,0)),
            text(x1+R/n/4, z1-0.008, "R"),
            text(x2-r/n/2.5, z2-0.008, "r"),
            text(x1+y/n/2-0.008, 0.89, "y")),
            text(x1-0.04, z1+R/n+0.2*vt1, "v<sub>R</sub>"), 
            text(x2+0.015, z2+r/n+0.2*vt2, "v<sub>r</sub>"),
         (context(), Compose.circle(x1, z1, R/n), fill("steelblue3"), stroke("white")),
         (context(),Compose.circle(x2, z2, r/n), fill("darkgoldenrod3"), stroke("white")))
    end
end

runA7[] = false
labelA7 = Observable("time (s)")
txtA7 = Observable((0.0,0.0,0.0))

onoffA7 = widget(false, label = "Start")

function collision_app7(r)
     if r == true
         global timerA7 = fpsA7(10.0)
     else
         runA7[] = false
         global timerA7[] = 0.1
     end
end

map(collision_app7, onoffA7)
b = map(i->round(i,digits = 1), timerA7)

Rx = slider(5:1.0:20, value = 20.0, label = "R")
rx = slider(5:1.0:20, value = 10.0, label = "r")
y = slider(0:1.0:50, value = 22.0, label = "y")
z = slider(5:1.0:100, value = 42.0, label = "z")
display(hbox(Rx,rx,y,z,onoffA7))
map(anim2,Rx,rx,y,z,timerA7)