using Gadfly, CSV, DataFrames, SpecialFunctions, NumericIO, Interact


function ulbricht1(D,R,μ)
	N₀(μ) = 6e3*0.1^μ*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = 10.0*(3.67 + μ)*(2e6*exp(3.2*μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*R^δ
	N₀(μ)*D^μ*exp(-Λ(μ,D₀)*D)
end

function rain_app5(μ)
	D = 0.0:0.1:5
	N₀(μ) = 6e3*0.1^μ*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = 10.0*(3.67 + μ)*(2e6*exp(3.2*μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*RR^δ

	str1 = formatted(N₀(μ), :SCI, ndigits=3) 
	str2 = 	@sprintf(" m<sup>-3</sup> mm<sup>%.1f</sup>, μ = %.1f, Λ = %.2f mm<sup>-1</sup>, D<sub>0</sub> = %.2f mm",
	       -1.0-μ, μ, Λ(μ,D₀), D₀)
	tstr = "N₀ = "*str1*str2
	ND = ulbricht1.(D,RR,μ)
	label = ["N<sub>0</sub>D<sup>μ</sup>exp(-ΛD)" for i = 1:length(D)]
	plot(layer(x = df[!,:D], y = df[!,:N], color = df[!,:R], Geom.point, 
		Gadfly.style(point_size = 1.5Gadfly.pt)),
		layer(x = D, y = ND, color = label, Geom.line),
		Guide.xlabel("Diameter (mm)"),
		Guide.ylabel("N(D) (mm<sup>-3</sup> mm<sup>-1</sup>)"),
		Guide.title(tstr), 
	 	Scale.color_discrete_manual("darkgreen", "darkgoldenrod3",  "darkred", "black"),
		Scale.y_log10(),
		Coord.cartesian(xmin = 0, xmax = 5, ymin = -1, ymax = 4))
end

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

μRA5 = slider(-3:0.1:3, value = 0.0, label = "μ")
display(μRA5)
map(rain_app5,μRA5)