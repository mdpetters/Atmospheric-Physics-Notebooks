# +
# This file contains the basic DMAconfig functions (viscosity,transfer function etc.)
#
# Author: Markus Petters (mdpetter@ncsu.edu)
# 	      Department of Marine Earth and Atmospheric Sciences
#         NC State University
#         Raleigh, NC 27605
#
#         May, 2018
#-

# λ functions
clean = x -> map(x -> x < 0.0 ? 0.0 : x, x)
Σ = (f,i) -> mapreduce(f,+,1:i)
λ = Λ -> 6.6e-8*(101315.0./Λ.p)*(Λ.t/293.15)
η = Λ -> 1.83245e-5*exp(1.5*log(Λ.t/296.1))*(406.55)/(Λ.t+110.4)
cc = (Λ,d) -> 1.0 .+ λ(Λ)./d.*(2.34.+1.05.*exp.(-0.39.*d./λ(Λ)))
dab = (Λ,d) -> kb*Λ.t*cc(Λ,d)./(3.0π*η(Λ)*d)
dtoz = (Λ,d) -> ec.*cc(Λ,d)./(3.0π.*η(Λ).*d)

u = (Λ,D) -> @. D*Λ.leff/Λ.qsa
Peff = u -> @. 0.82*exp(-11.5u)+0.1*exp(-70.0u)+0.03*
		exp(-180.0u)+0.02*exp(-340.0u)
Taf = (x,μ,σ) -> @. 0.5*(1.0 + erf((x-μ)/(√2σ)))
Tl = (Λ,dp) -> clean(Peff(u(Λ,dab(Λ,dp*1e-9))))

function getTc(Λ)
	if Λ.polarity == :+    # positive polarity power supply
		A1 = convert(Array{Float64}, ax[:n1])
		A2 = convert(Array{Float64}, ax[:n2])
	elseif Λ.polarity == :-
		A1 = convert(Array{Float64}, ax[:p1])
		A2 = convert(Array{Float64}, ax[:p2])
	end

	fc = Function[]
	xi = d -> log10.(d)
	f1 = d -> 10.0.^(A1[1]*xi(d).^0.0 + A1[2]*xi(d).^1.0 + A1[3]*xi(d).^2.0 +
					 A1[4]*xi(d).^3.0 + A1[5]*xi(d).^4.0 + A1[6]*xi(d).^5.0)
	f2 = d -> 10.0.^(A2[1]*xi(d).^0.0 + A2[2]*xi(d).^1.0 + A2[3]*xi(d).^2.0 +
					 A2[4]*xi(d).^3.0 + A2[5]*xi(d).^4.0 + A2[6]*xi(d).^5.0)
	push!(fc,f1)
	push!(fc,f2)

	for i = 3:Λ.m
		fi = @. dp -> ec./(sqrt.(4.0*π^2.0*eps*dp*1e-9*kb*Λ.t)) .*
	          exp.(-(i*1.0 - 2.0*π*eps*dp*1e-9*kb*Λ.t*
					log(0.875)/ec.^2.0).^2.0./
				   (4.0*π*eps*dp*1e-9*kb*Λ.t/ec^2.0))
	    push!(fc,fi)
	end
	return Tc = (k,Dp) -> fc[k](Dp)
end

# V-toZ and Z-to-D implementation
vtoz = (Λ,v) -> (Λ.DMAtype == :radial) ? Λ.qsh.*Λ.l/(π.*(Λ.r2^2.0-Λ.r1^2)*v) :
                                         Λ.qsh./(2.0π.*Λ.l.*v).*log(Λ.r2/Λ.r1)

ztov = (Λ,z) -> (Λ.DMAtype == :radial) ? Λ.qsh.*Λ.l/(π.*(Λ.r2^2.0-Λ.r1^2)*z) : 
										 Λ.qsh./(2.0π.*Λ.l.*z).*log(Λ.r2/Λ.r1)

f = (Λ,i,z,di) -> @. i.*ec.*cc($Ref(Λ),di)./(3.0π.*η($Ref(Λ)).*z)
converge = (f,g) -> maximum(abs.(1.0 .- f./g).^2.0) < 1e-20
g = (Λ,i,z,di) -> converge(f(Λ,i,z,di),di) ? di : g(Λ,i,z,f(Λ,i,z,di))
ztod = (Λ,i,z) -> g(Λ,i,z,di).*1e9;

# DMAconfig transfer function from Stolzenburg and McMurry (2008)
function Ω(Λ,Z,zs)
	ε = (x) -> @. x*erf(x) .+ exp(-x^2.0)/√π
	D = dab(Λ,ztod(Λ,1,zs)*1e-9)
	β = Λ.qsa/Λ.qsh
	γ = (Λ.r1/Λ.r2)^2.0
	I = 0.5(1.0+γ)
	κ = Λ.l*Λ.r2/(Λ.r2^2.0-Λ.r1^2.0)
	G = 4.0(1.0+β)^2.0/(1.0-γ) * (I+(2.0(1.0+β)κ)^(-2.0))
	σ = √(G*2.0π*Λ.l*D/Λ.qsh)
	f = (Z,σ,β,ε) -> @. σ/(√2.0*β)*(ε((Z-(1.0+β))/(√2.0*σ)) +
								 ε((Z-(1.0-β))/(√2.0*σ)) -
							     2.0*ε((Z-1.0)/(√2.0*σ)))
	return clean(f(Z/zs,σ,β,ε))
end

function mylogspace(a::Float64,b::Float64,n::Int)
    x = Float64[]
	push!(x, a)
    step = 10.0^(log10(b/a)/(n-1))
    for i = 2:1:n
		push!(x, x[i-1]*step)
	end
    return x
end

function Ωav(Λ,i,k;nint = 20)
	Vex = mylogspace(Ve[i], Ve[i+1], nint)
	return mapreduce(zˢ->Ω(Λ,Z,zˢ/k), +, vtoz(Λ, Vex))/nint
end

function setupSMPS(Λ, v1, v2, tscan, tc)
   bins = round(Int,tscan/tc) # Number of size bins
   global Ve = reverse(10 .^ range(log10(v1),stop=log10(v2),length=bins+1))  # Voltage bin-edges
   global Vp = sqrt.(Ve[2:end].*Ve[1:end-1])  # Voltage midpoints
   global Tc = getTc(Λ)
   global Ze = vtoz(Λ,Ve)
   global Z = vtoz(Λ,Vp)
   global Dp = ztod(Λ,1,Z)
   global De = ztod(Λ,1,Ze)
   global ΔlnD = log.(De[1:end-1]./De[2:end])
   T = (i,k,Λ) -> Ωav(Λ,i,k).*Tc(k,Dp).*Tl(Λ,Dp)
   global 𝐀 = (hcat(map(i->Σ(k->T(i,k,Λ),Λ.m),1:bins)...))'
   global 𝐎 = (hcat(map(i->Σ(k->Ωav(Λ,i,k).*Tl(Λ,Dp),1),1:bins)...))'
   n,m = size(𝐀)
   𝐒 = zeros(n,m)
   for i = 1:n
	   𝐒[i,i] = sum(𝐀[i,:])
   end
   return DifferentialMobilityAnalyzer(Ωav,Tc,Tl,Z,Ze,Dp,De,ΔlnD,𝐀,𝐒,𝐎)
end

function setupSMPSdata(Λ, V)
   tc = 1
   global Ve = V
   global bins = length(Ve)-1
   global Vp = sqrt.(Ve[2:end].*Ve[1:end-1])  # Voltage midpoints
   global Tc = getTc(Λ)
   global Ze = vtoz(Λ,Ve)
   global Z = vtoz(Λ,Vp)
   global Dp = ztod(Λ,1,Z)
   global De = ztod(Λ,1,Ze)
   global ΔlnD = log.(De[1:end-1]./De[2:end])

   T = (i,k,Λ) -> Ωav(Λ,i,k).*Tc(k,Dp).*Tl(Λ,Dp)
   global 𝐀 = (hcat(map(i->Σ(k->T(i,k,Λ),Λ.m),1:bins)...))'
   global 𝐎 = (hcat(map(i->Σ(k->Ωav(Λ,i,k).*Tl(Λ,Dp),1),1:bins)...))'
   n,m = size(𝐀)
   𝐒 = zeros(n,m)
   for i = 1:n
	   𝐒[i,i] = sum(𝐀[i,:])
   end
   return DifferentialMobilityAnalyzer(Ωav,Tc,Tl,Z,Ze,Dp,De,ΔlnD,𝐀,𝐒,𝐎)
end


function setupDMA(Λ, z1, z2, bins)
	global Tc = getTc(Λ)
	global Ze = 10 .^ range(log10(z1),stop=log10(z2),length=bins+1)
	global Z = sqrt.(Ze[2:end].*Ze[1:end-1])
	global Dp = ztod(Λ,1,Z)
	global De = ztod(Λ,1,Ze)
	global ΔlnD = log.(De[1:end-1]./De[2:end])
	T = (zˢ,k,Λ) -> Ω(Λ,Z,zˢ/k).*Tc(k,Dp).*Tl(Λ,Dp)
    global 𝐀 = (hcat(map(zˢ->Σ(k->T(zˢ,k,Λ),Λ.m),Z)...))'
	global 𝐎 = (hcat(map(i->Σ(k->Ω(Λ,Z,i/k).*Tl(Λ,Dp),1),Z)...))'
	n,m = size(𝐀)
	𝐒 = zeros(n,m)
	for i = 1:n
		𝐒[i,i] = sum(𝐀[i,:])
	end
	return DifferentialMobilityAnalyzer(Ω,Tc,Tl,Z,Ze,Dp,De,ΔlnD,𝐀,𝐒,𝐎)
end
