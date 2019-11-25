module DifferentialMobilityAnalyzers
# +
# This file defines the module DifferentialMobilityAnalyzers.jl
#
# Author: Markus Petters (mdpetter@ncsu.edu)
# 	      Department of Marine Earth and Atmospheric Sciences
#         NC State University
#         Raleigh, NC 27605
#
#         May, 2018
#-

using Interpolations
using SpecialFunctions
using DataFrames
using Calculus
using LinearAlgebra
using Random
using Distributions
using Plots

import
	Base.*,                   # Import to extend operators
	Base./,                   # Import to extend operators
	Base.+,                   # Import to extend operators
	LinearAlgebra.⋅

export
	DMAconfig,                    # Data type to hold DMA config
	DifferentialMobilityAnalyzer, # Data type to hold grid and matrices
	SizeDistribution,         # Data type to hold size distribution
	Regvars,                  # Data type to hold regularization problem
	Ψ,                        # Data structure that contains regvars
	setupDMA,                 # Function to initialize DMA
	setupSMPS,                # Function to initialize SMPS
    setupSMPSdata, # Function to initialize SMPS with data
	setupRegularization,      # Function to initialize regularization
	clean,                    # Function to remove negative numbers
	Σ,                        # Function to sum functions
	λ,                        # Function to compute mean free path
	η,                        # Function to compute air viscosity
	cc,                       # Function to compute slip-flow correction
	dab,                      # Function to compute diffusion coefficient
	vtoz,                     # Function to convert Voltage to Mobility
	ztov,                     # Function to convert Mobility to Voltage
	dtoz,                     # Function to convert Diameter to Mobility
	ztod,                     # Function to convert Mobility to Diameter
	lognormal,                # Function to compute lognormal size dist
	triangular,               # Function to compute DMA triangular size dist
	DMALognormalDistribution, # Function to compute lognormal size dist
	reginv,                   # Function to compute regularized inverse
	lcurve,                   # Function to compute the L-curve
	lcorner,                  # Function to find corner of L-curve
	rinv,					  # Function to compute the inverse
	loadtsidata,              # Function to loads TSI data file; loadtsidata.
    β12brown,                 # Brownian coagualation kernel
	β12zebel,                 # Zebel charge enhancement
	β12,                      # Brownian+Zebel coagulation kernel
	figure					  # Function to setup figures

### Data types

# Data type to describe DMA
struct DMAconfig
	t::Float64                # Temperature [K]
	p::Float64                # Pressure [Pa]
    qsa::Float64              # Sample flow [m3 s-1]
	qsh::Float64              # Sheath flow [m3 s-1]
	r1::Float64               # Inner column radius [m]
	r2::Float64               # Outer column radius [m]
	l::Float64                # Column length [m]
	leff::Float64             # Effective length [m]
	polarity::Symbol          # Power supply polarity [:+] or [:-]
	m::Int8                   # Number of charges in charge correction [-]
	DMAtype::Symbol           # Designate :radial, :cylindrical
end

# Data type to facility DMA caluclations
struct DifferentialMobilityAnalyzer
	Ω::Function                    # DMA transfer function
	Tc::Function                   # Charge filter Function
	Tl::Function                   # DMA Penetration efficiency function
	Z::Array{Float64,1}            # Mobility array midpoints
	Ze::Array{Float64,1}           # Mobility array bin edges
	Dp::Array{Float64,1}           # Mobility diameter midpoints
	De::Array{Float64,1}           # Mobility diameter bin edges
	ΔlnD::Array{Float64,1}         # ln(de[i+1])-ln(de[i])
	𝐀::Array{Float64,2}            # Convolution matrix
	𝐒::Array{Float64,2}            # Convolution matrix for initial guess
	𝐎::Array{Float64,2}            # Convolution matrix for no charge filter
end

# Data type that is used to describe the size distributions
mutable struct SizeDistribution
	A::Any                   # Input parameters [[N1,Dg1,σg1], ...] or DMA
	De::Array{Float64,1}     # bin edges
	Dp::Array{Float64,1}     # bin midpoints
	ΔlnD::Array{Float64,1}   # ΔlnD of the grid
	S::Array{Float64,1}      # spectral density
	N::Array{Float64,1}      # number concentration per bin
	form::Symbol             # form of the size distributio [:lognormal, ....]
end

# Data type that is used to describe the reguarization
struct Regvars
    𝐀::Array{Float64,2}      # Convolution matrix
    𝐈::Array{Float64,2}      # Identity matrix
    B::Array{Float64,1}      # residual vector
    X₀::Array{Float64,1}     # initial guess
end

### Constants
const kb = 1.38064852e-23    # Boltzmann constant      [J K-1 molec-1]
const r = 8.314472           # Universal gas const     [J K-1 mol-1]
const ec = 1.602176565e-19   # Elemental charge        [C]
const eps = 8.854187817e-12  # Dielectric constant     [farad m-1]
const na = 6.02214086e23     # Avagadro's constant     [molecule mol-1]
const mwair = 28.9647e-3     # Molecular weight of air [kg mol-1]
const di = 1e-7              # Initial guess diameter  [m]

# Coefficients for charge polynomials taken from TSI Manual.
# n2: negative 2 charges, p2: positive 2 charges on PARTICLE
const ax = DataFrame(
	   n2 = [-26.3328, 35.9044, -21.4608, 7.0867, -1.3088, 0.1051],
  	   n1 = [-2.3197, 0.6175, 0.6201, -0.1105, -0.1260, 0.0297],
	   p1 = [-2.3484, 0.6044, 0.4800, 0.0013, -0.1553, 0.0320],
	   p2 = [-44.4756, 79.3772, -62.8900, 26.4492, -5.7480, 0.5049])

### Source files
include("dmafunctions.jl")
include("aerosolsizedistributions.jl")
include("regularization.jl")
include("loadtsidata.jl")
include("coagulationrates.jl")
include("myfigure.jl")

end
