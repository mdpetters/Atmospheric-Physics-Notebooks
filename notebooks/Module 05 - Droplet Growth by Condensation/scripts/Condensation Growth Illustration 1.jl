using Gadfly, Compose, Colors, Random, Distributions

function condensation_illustration1()
    Random.seed!(412)
    r = 1.13 .- rand(Exponential(0.15), 9000)
    c = (r .<= 0.05) 
    deleteat!(r,c)
    θ = rand(length(r)).*2π/2.3 .- π./2.3

    x(r,θ) = 0.5+r*cos(θ)
    y(r,θ) = 0.5+r*sin(θ)

    xx = x.(r,θ)
    yy = y.(r,θ)

    c = (xx .> 0.805) .| (xx .< 0.55)
    deleteat!(xx,c)
    deleteat!(yy,c)

    set_default_graphic_size(20Compose.cm, 8Compose.cm)    
    compose(context(), text(0.51,0.47, "r"), text(0.6,0.59, "R"), text(0.8,0.83, "S<sub>∞</sub>"),
                    text(0.545,0.61, "S<sub>r</sub>"), text(0.67,0.78, "J<sub>v</sub>"),
            (context(), text(0.545,0.41, "T<sub>r</sub>"), text(0.8,0.32, "T<sub>∞</sub>"), 
                        text(0.67,0.32, "J<sub>h</sub>"),fill("black")),
            (context(), line([(0.70, 0.75), (0.63, 0.68)]), line([(0.62, 0.43), (0.70, 0.37)]),
                        stroke("black"), arrow(), linewidth(0.5Compose.mm)),
            (context(), Compose.circle(0.5, 0+0.5, 0.05), fill(RGBA(0.31,0.58,0.8,0.5)),  
                    stroke("black"),strokedash([2Compose.mm,2Compose.mm]),linewidth(0.3Compose.mm)),
            (context(), arc([0.5], [0.5], [0.18], [-π/3], [true]), fill("transparent"), 
                        stroke("black"), strokedash([2Compose.mm,2Compose.mm])),
            (context(), line([(0.5, 0.5), (0.54,0.44)]), stroke("black")),
            (context(), line([(0.5, 0.5), (0.665,0.665)]), stroke("black")),
            (context(), Compose.circle([xx;], [yy;], [0.0025]), fill("steelblue3")),
        
        )
end

condensation_illustration1()