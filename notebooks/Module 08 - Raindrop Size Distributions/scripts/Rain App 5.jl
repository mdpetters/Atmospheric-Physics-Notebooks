using Gadfly, CSV, DataFrames, SpecialFunctions, NumericIO, Interact

function Zfactor(R,μ)
	N₀(μ) = 6e3*0.1^μ*exp(3.2*μ)
	Λ(μ,D₀) = (3.67 + μ)/D₀
	δ = 1.0/(4.67 + μ)
	ε = 10.0*(3.67 + μ)*(2e6*exp(3.2*μ)*gamma(4.67+μ))^(-δ)
	D₀ = ε*R^δ
	R = 7.1265e-3*gamma(4.67+μ)/(3.67+μ)^(4.67+μ) * N₀(μ) * D₀^(4.67+μ)
	Z = gamma(7.0+μ)/(3.67+μ)^(7.0+μ) * N₀(μ) * D₀^(7.0+μ)
end

function rain_app5(μ,a,b)
	df = CSV.read("figures/ZRdata1.csv")
	Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)
	R = gengrid([0.1,1,10])
	Z = Zfactor.(R, μ)
	Z1 = @. a*R^b
	label = ["Z-R from N<sub>0</sub>D<sup>μ</sup>exp(-ΛD)" for i = 1:length(R)]
	label1 = ["Z=aR<sup>b</sup>" for i = 1:length(R)]
	plot(layer(x = df[!,:R], y = df[!,:Z], 
	            Gadfly.style(default_color=colorant"slategrey", point_size=3Gadfly.pt),
	            shape = df[!,:Location], Geom.point),
		 layer(x = R, y = Z, color = label, Geom.line),
		 layer(x = R, y = Z1, color = label1, Geom.line),
		 Theme(key_swatch_color=colorant"slategrey"),
		 Guide.xlabel("Rainfall rate (mm hr<sup>-1</sup>)"),
		 Guide.ylabel("Reflectivity factor Z (mm<sup>6</sup> m<sup>-3</sup>)"),
	 	 Scale.color_discrete_manual("black", "darkgoldenrod3",  "darkred", "black"),
		 Scale.y_log10(),
		 Scale.x_log10(),
		 Coord.cartesian(xmin = -1, xmax = 2, ymin = 0, ymax = 6))
end

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

μRA5 = slider(-3:0.1:3, value = 0.0, label = "μ")
aRA5 = slider(200:10:600, value = 400.0, label = "a")
bRA5 = slider(1.0:0.05:2, value = 1.5, label = "b")
display(μRA5)
display(hbox(aRA5,bRA5))
map(rain_app5,μRA5,aRA5,bRA5)