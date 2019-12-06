using Gadfly, Compose, Contour

function collision_app8()
    u = 2.0
    r = 2.0

    Ψ(a,θ) = 1.0/4.0*u*(2*r^2.0 - 3*a*r +  a^3*r^-1)*sin(θ)^2.0
    rxx(x,y) = sqrt(x^2 + y^2)

    function θxx(x,y) 
        if (x > 0) & (y > 0)
            atan(y/x)
        elseif (x < 0) & (y > 0)
            atan(y/x) + π
        elseif (x > 0) & (y < 0)
            atan(y/x) + 2π
        elseif (x < 0) & (y < 0)
            atan(y/x) + π
        elseif (y == 0)
            atan(0)
        elseif (x == 0) & (y == 0)
            atan(0)
        end
    end

    xx =  -4:0.12:16
    yy =  -6:0.11:6
    tθ = [θxx(x,y) for x =xx, y = yy]
    tr = [rxx(x,y) for x = xx, y = yy]
    tz =  [Ψ(tr[i,j],tθ[i,j]) for i=1:length(xx), j=1:length(yy)] 

    lvl = levels(contours(xx,yy,tz,[0.1,1,4,8,15]))
    a = map(lvl) do line
        l = lines(line)
        map(l) do i
            xs, ys = coordinates(i) 
            [((ys[i]+10.0)./20,(xs[i]+5.0)./20) for i = 1:length(xs)]
        end
    end

    set_default_graphic_size(10Compose.cm, 10Compose.cm)

    compose(context(), stroke("black"), linewidth(0.15Compose.mm), 
            line(a[1]), line(a[2]), line(a[3]), line(a[4]), line(a[5]),
            (context(), Compose.circle(0.5, 0.25, 0.1), fill("steelblue3")),
            (context(), Compose.circle(0.44, 0.6, 0.03), fill("darkgoldenrod3"), stroke("white")),
            (context(), Compose.circle(0.37, 0.31, 0.03), fill(RGBA(0.8,.61,0.11,0.3)), stroke("black")),
            (context(), Compose.circle(0.36, 0.24, 0.03), fill(RGBA(0.8,.61,0.11,0.3)), stroke("black")),
            (context(), Compose.circle(0.38, 0.17, 0.03), fill(RGBA(0.8,.61,0.11,0.3)), stroke("black")),
            (context(), Compose.circle(0.58, 0.35, 0.03), fill(RGBA(0.55,0,0,0.3)), stroke("black")),
            (context(), Compose.circle(0.54, 0.58, 0.03), fill("darkred"), stroke("white")),
            (context(), stroke("black"), arrow(), linewidth(0.25Compose.mm), 
                        line([(0.5,0.3), (0.5, 0.5)])),
            (context(), stroke("black"), arrow(), linewidth(0.25Compose.mm), 
                        line([(0.43,0.57), (0.38, 0.36)]),
                        line([(0.55,0.55), (0.57, 0.41)])))
end

collision_app8()