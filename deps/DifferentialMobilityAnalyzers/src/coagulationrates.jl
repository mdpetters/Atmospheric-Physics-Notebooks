
function β12brown(Dp_i, Dp_j;
				  ρi = 1000.0, ρj = 1000.0, p = 1e5, T = 293.0)
# +
# coagulation kernel from eqn 15.33 of Jacobson (2005) text
#
# ρair  = air density (kg/m^3)
# ηd    = air dynamic viscosity (kg/m/s)
# ηk    = air kinematic viscosity (m^2/s)
# v     = air molecule mean thermal velocity (m/s)
# gasλ  = air molecule mean free path (m)
#
# diffus_i/j  = particle brownian diffusion coefficient  (m^2/s)
# speedsq_i/j = square of particle mean thermal velocity (m/s)
# λ           = particle mean free path (m)
# Cc          = cunningham slip-flow correction factor
# δsq_i/j     = square of "delta_i" in eqn 15.34
#
# bckernel    = brownian coagulation kernel (m3/s)
#
# Adapted to from PartMC frortran code (author: Nicole Riemer/Matthew West)
#
# Markus Petters (mdpetter@ncsu.edu)
# Department of Marine Earth and Atmospheric Sciences
# NC State University
# Raleigh, NC 27965
# April 2018
#-

Rme_i, Rme_j = Dp_i/2.0, Dp_j/2.0
rad_i, rad_j = Rme_i, Rme_j
vol_i, vol_j = 4.0π*Rme_i^3.0/3.0,4.0π*Rme_j^3.0/3.0

ρair = (p*mwair)/(r*T)
ηd   = 1.8325e-05*(416.16/(T+120.0))*(T/296.16)^1.5
ηk   = ηd/ρair
v    = sqrt((8.0*kb*T*na)/(π*mwair))
gasλ = 2.0*ηk/v

Kn        = gasλ/Rme_i
Cc        = 1.0 + Kn*(1.249 + 0.42*exp(-0.87/Kn))
diffus_i  = (kb * T * Cc) / (6.0 * π * Rme_i * ηd)
speedsq_i = 8.0 * kb * T / (π * ρi * vol_i)
λ         = 8.0 * diffus_i /(π * sqrt(speedsq_i))
tmp1      = (2.0 * Rme_i + λ)^3.0
tmp2      = (4.0 * Rme_i*Rme_i + λ * λ)^1.5
δsq_i     = ( (tmp1 - tmp2)/(6.0 * Rme_i * λ) - 2.0*Rme_i )^2.0

Kn        = gasλ/Rme_j
Cc        = 1.0 + Kn*(1.249 + 0.420*exp(-0.87/Kn))
diffus_j  = (kb * T * Cc) / (6.0 * π * Rme_j * ηd)
speedsq_j = 8.0 * kb * T / (π * ρj * vol_j)
λ         = 8.0 * diffus_j / (π * sqrt(speedsq_j))
tmp1      = (2.0*Rme_j + λ)^3.0
tmp2      = (4.0*Rme_j*Rme_j + λ*λ)^1.5
δsq_j     = ( (tmp1 - tmp2)/(6.0*Rme_j * λ) - 2.0*Rme_j )^2.0

rad_sum    = rad_i + rad_j
diffus_sum = diffus_i + diffus_j
tmp1       = rad_sum/(rad_sum + sqrt(δsq_i + δsq_j))
tmp2       = 4.0*diffus_sum/(rad_sum*sqrt(speedsq_i + speedsq_j))
bckernel   = 4.0*π*rad_sum*diffus_sum/(tmp1 + tmp2)

return bckernel
end

function β12zebel(Dp_i, Dp_j, q_i, q_j;
				  ρi = 1000.0, ρj = 1000.0, p = 1e5, T = 293.0)
# +
# calculate enhancement factor for coagulation based on charges
# q_i and q_j using Zebel (1957) theory.
# Zebel, Zur Theorie des Verhaltens elektrisch geladener Aerosole
# Kolloid-Zeitschrift, Band 157/9
#
# Markus Petters (mdpetter@ncsu.edu)
# Department of Marine Earth and Atmospheric Sciences
# NC State University
# Raleigh, NC 27965
# April 2018
#-


Rme_i, Rme_j = Dp_i/2.0, Dp_j/2.0
rad_i, rad_j = Rme_i, Rme_j
vol_i, vol_j = 4.0π*Rme_i^3.0/3.0,4.0π*Rme_j^3.0/3.0

ρair = (p*mwair)/(r*T)
ηd   = 1.8325e-05*(416.16/(T+120.0))*(T/296.16)^1.5
ηk   = ηd/ρair
v    = sqrt((8.0*kb*T*na)/(π*mwair))
gasλ = 2.0*ηk/v

Kn        = gasλ/Rme_i
Cc        = 1.0 + Kn*(1.249 + 0.42*exp(-0.87/Kn))
diffus_i  = (kb * T * Cc) / (6.0 * π * Rme_i * ηd)

Kn        = gasλ/Rme_j
Cc        = 1.0 + Kn*(1.249 + 0.420*exp(-0.87/Kn))
diffus_j  = (kb * T * Cc) / (6.0 * π * Rme_j * ηd)

Dij = (diffus_i + diffus_j)
rij = (rad_i + rad_j)
m_i = π/6.0 * Dp_i^3.0 * ρi
m_j = π/6.0 * Dp_j^3.0 * ρj

G0 = Dij/rij * 4.0*√(m_i*m_j/((m_i + m_j)*3.0*kb*T))  # pg. 44
#eskT = 5.74e-8             # Term e^2/kT. Value from pg 40 [m]
es = 1.4399643929 * 1.60218e-13 * 1e-15  # convert to J m-1
eskT = es./(kb*T)
a = q_i*q_j*eskT;

return a ≠ 0.0 ? (a/rij)/(exp(a/rij)-1.0 + G0*(a/rij)*exp(a/rij)) : 1.0
end


function β12(Dp_i, Dp_j, q_i, q_j;
				  ρi = 1000.0, ρj = 1000.0, p = 1e5, T = 293.0)
	k1 = β12brown(Dp_i, Dp_j; ρi=ρi, ρj=ρj,p=p,T=T)
	k2 = β12zebel(Dp_i, Dp_j, q_i, q_j)
	return k1*k2
end
