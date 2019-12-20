using Gadfly, CSV, DataFrames, Interact, Printf

function rain_app2(N₀,μ,Λ)
	Gadfly.set_default_plot_size(17Gadfly.cm, 9Gadfly.cm)

	D = 0.0:0.1:10
	N(D) = N₀*D^μ*exp(-Λ*D)
	tstr = @sprintf("N₀ [m<sup>-3</sup> mm<sup>%.1f</sup>], μ [-], Λ [mm<sup>-1</sup>]",-1.0-μ)
	label = ["N<sub>0</sub>D<sup>μ</sup>exp(-ΛD)" for i = 1:length(D)]
    plot(layer(x = D, y = N.(D), Gadfly.style(default_color=colorant"black"), Geom.line),
	     Guide.xlabel("Diameter (mm)"),
		 Guide.ylabel("N(D) (mm<sup>-3</sup> mm<sup>-1</sup>)"),
		 Guide.title(tstr),
	     Scale.y_log10(),
     	 Coord.cartesian(xmin = 0, xmax = 10, ymin = -4, ymax = 4))
end

gengrid(r) = [vcat(map(x->x:x:8x,r)...);r[end]*10]

N0RA2 = slider(gengrid([1e1,1e2,1e3]), value = 1e3, label = "N₀")
μRA2 = slider(-3:0.1:3, value = 0.0, label = "μ")
ΛRA2 = slider(1:0.1:3, value = 3.0, label = "Λ")

display(hbox(N0RA2,μRA2,ΛRA2))
map(rain_app2, N0RA2, μRA2, ΛRA2)