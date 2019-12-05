module AtmosphericThermodynamics

using Roots

const g = 9.81       # Acceleration due to graviation [m s-2]
const Mv = 0.018015  # Molecular weight of water [kg mol-1]
const Md = 0.02897   # Molecular weight of dry air [kg mol-1]
const NA = 6.022e23  # Avogadro's constant [molecules mol-1]
const kB = 1.318e-23 # Boltzmann constant [J molecule-1 K-1]
const R = 8.3145     # Universal gas constant [J mol-1 K-1]
const Rd = 287.5     # Specific gas constant for dry air [J kg-1 K-1]
const Rv = 461.5     # Specific gas constant for dry air [J kg-1 K-1]
const cp = 1005.5    # Heat capacity of dry air at constant pressure [J kg-1 K-1] 
const cv = 717.0     # Heat capacity of dry air at constant volume [J kg-1 K-1] 
const Lv = 2.5e6     # Enthalpy of vaporization [J kg-1]
const Lf = 0.334e6   # Enthalpy of fusion [J kg-1]
const rhow = 997.1   # Density of water at 0C [kg m-3] 
const ϵ = Mv/Md      # Ratio of molecular weights
const κ = 1.0-cv/cp  # Used in Poisson equation

export g,Mv,Md,NA,kB,R,Rd,Rv,cp,cv,Lv,Lf,rhow,ϵ,κ
export es,ws,Θ,G,λ,η,Cc,ρg,Re,Cd,vt

Dv(T,p) = 2.11e-5*(T/273.15)^1.94*(1e5/p)                    # Unit [m2 s-1]
K(T) = 25.87*1e-3(T/293.15)^0.9                              # Unit [J s-1 m-1 K-1]   
es(T) = 610.94*exp(17.625*(T-273.15)/((T-273.15) + 243.04))  # saturation vapor pressure
ws(T,p) = ϵ*es(T)/(p-es(T))                                  # mixing ratio
Θ(T,p) = T*(1e5/p)^κ                                         # potential temperature 
z(p) = log(1e5/p)*8000.0                                     # scale height equation
p(z) = 1e5*exp(-z/8000.0)                                    # scale height equation 
G(T,p) = 1/((rhow*R*T)/(es(T)*Dv(T,p)*Mv) + (Lv*rhow)/(K(T)*T)*((Lv*Mv)/(T*R)-1.0));


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

function wl(TLCL, zLCL, Δz)
    pLCL = p(zLCL)                             # pressure at LCL
    T2, p2 = Tp(TLCL, zLCL, Δz)                # temperature and pressure at Δz
    ws(TLCL,pLCL)-ws(T2,p2)                    # adiabatic liquid water content at Δz
end
    
function Tp(TLCL, zLCL, Δz)
    pLCL = p(zLCL)                             # pressure at LCL
    Θₑ = Θ(TLCL + ws(TLCL,pLCL)*Lv/cp, pLCL)   # eq. pot. temp at LCL
    p2 = p(zLCL + Δz)                          # p at point above LCL
    f(T) = Θₑ/(1e5 / p2)^κ - ws(T, pLCL)*Lv/cp - T; 
    fzero(f, 250.0), p2                        # Temperature, pressure at Δz
end

end