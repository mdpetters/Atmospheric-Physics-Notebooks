module RunPartMC
# +
# Module that serves as wrapper to run PartMC
#
# Author: Markus Petters (mdpetter@ncsu.edu)
# 	      Department of Marine Earth and Atmospheric Sciences
#         NC State University
#         Raleigh, NC 27605
#
#         April, 2018
#-

using
	NetCDF,        # Needed for parsing PartMC output
	StatsBase,     # Needed for histograms
	Glob,          # Needed to parse folders
	Printf,
	DifferentialMobilityAnalyzers # Needed for aerosol size distributions

struct InitialConditionTriangular
	Nt1::Float64   # Number concentration mode 1
	Nt2::Float64   # Number concentration mode 2
	Dm::Float64    # Mode diameter
	Λ::DMAconfig   # DMA conditions
	δ::DifferentialMobilityAnalyzer     # DMA functions
end

struct InitialConditionLogNormal
	Nt1::Float64   # Number concentration mode 1
	Nt2::Float64   # Number concentration mode 2
	Dm::Float64    # Mode diameter
	σ::Float64     # Geometric standard deviation
end

struct PartMCOutput
	t::Float64               # total time of simulation
	s1::SizeDistribution     # reconstructed size distribution mode 1
	s2::SizeDistribution     # reconstructed size distribution mode 2
	sc12::SizeDistribution   # reconstructed size distribution 1/2 dimers
	sca::SizeDistribution    # reconstructed size distribution all coag.
	k12::Float64             # apparent dimer formation rate
	ka::Float64              # apparent coagulation rate
end

struct Simulation
	case::Any                # Initial condition
	s1::SizeDistribution     # reconstructed size distribution mode 1
	s2::SizeDistribution     # reconstructed size distribution mode 2
	r::Array{PartMCOutput}   # PartMC output for all repeats
	k12::Array{Float64,2}    # app. dimer coag, rate, all time steps/all repeats
	ka::Array{Float64,2}     # apparent coag, rate, all time steps/all repeats
end

export
	InitialConditionTriangular, # Data type
	InitialConditionLogNormal,  # Data type
	PartMCOutput,               # Data type
	Simulation,                 # Data type
	runSimulation               # Wrapper function


searchdir(path,key) = filter(x->occursin(x,key), readdir(path))

# This function generates the particle size distribution and writes the
# partMC input file.
function generatePSDTriangular(Λ,δ,A,i)
	psd = triangular(Λ, δ, A)    # get size distribution

	open("size_distribution$i.dat", "w") do f
	    write(f, "diam "*join([@sprintf "%e" x for x in psd.De./1e9], " ")*"\n")
		write(f, "num_conc "*join([@sprintf "%e" x for x in psd.N], " ")*"\n")
	end

	return psd
end

# This function generates the particle size distribution and writes the
# partMC input file.
function generatePSDLogNormal(A,i)
	psd = lognormal([A]; bins=512)    # get size distribution

	open("size_distribution$i.dat", "w") do f
	    write(f, "diam "*join([@sprintf "%e" x for x in psd.De./1e9], " ")*"\n")
		write(f, "num_conc "*join([@sprintf "%e" x for x in psd.N], " ")*"\n")
	end

	return psd
end

# This function processes the netCDF files produced by the partMC run
# The netCDF file is screened to construct the size distribution of the
# two input compounds and the 1/1 dimer
function readPSD(case,file,de)
	m = ncread(file, "aero_particle_mass")
	s = ncread(file, "aero_n_orig_part")
	n = ncread(file, "aero_num_conc")
	t = ncread(file, "time")
	ncclose(file)

	Dpca, Dpc12, Dp1, Dp2 = Float64[],Float64[],Float64[],Float64[]
	nca, nc12, n1, n2 = Float64[],Float64[],Float64[],Float64[]
	ρ=1000.0
	mtod = (m1,m2) -> 1e9(6.0(m1 + m2)/(π*ρ))^(1.0/3.0)
	for i = 1:length(m[:,1])
		if (s[i,1] == 1) & (s[i,2] == 0)
			push!(Dp1, mtod(m[i,1],0))
			push!(n1, n[i,1])
		elseif (s[i,1] == 0) & (s[i,2] == 1)
			push!(Dp2, mtod(0,m[i,2]))
			push!(n2, n[i,1])
		end

		if (s[i,1] == 1) & (s[i,2] == 1)
			push!(Dpc12, mtod(m[i,1],m[i,2]))
			push!(nc12, n[i,1])
		end

		if (s[i,1]+s[i,2]) ≥ 2
			push!(Dpca, mtod(m[i,1],m[i,2]))
			push!(nca, n[i,1])
		end
	end

	h1 = fit(Histogram, Dp1, weights(n1), de, closed = :right)
	h2 = fit(Histogram, Dp2, weights(n2), de, closed = :right)
	hc12 = fit(Histogram, Dpc12, weights(nc12), de, closed = :right)
	hca = fit(Histogram, Dpca, weights(nca), de, closed = :right)

	k12 = sum(hc12.weights)/(case.Nt1*case.Nt2*t[1])
	ka = sum(hca.weights)/((case.Nt1+case.Nt2)^2.0*t[1])

	dp = sqrt.(de[2:end].*de[1:end-1])
	dlnD = log.(de[2:end]./de[1:end-1])

	s1 = SizeDistribution([],de,dp,dlnD,h1.weights./dlnD,h1.weights,:partMC)
	s2 = SizeDistribution([],de,dp,dlnD,h2.weights./dlnD,h2.weights,:partMC)
	sc12 = SizeDistribution([],de,dp,dlnD,hc12.weights./dlnD,hc12.weights,:partMC)
	sca = SizeDistribution([],de,dp,dlnD,hca.weights./dlnD,hca.weights,:partMC)

	return PartMCOutput(t[1],s1,s2,sc12,sca,k12,ka)
end

function runSimulation(case::Any, c::Int, prefix::String;
					   verbose = false, repeat = 1)
	k12, ka = Array{Float64}(undef,repeat,5), Array{Float64}(undef,repeat,5)
	l = Simulation[]

	# Copy all input files in new directory
	x1, x2 = glob("*.dat"), glob("*.spec")
	read(`mkdir -p $prefix$c/`, String)
	read(`cp $x1 $prefix$c/`, String)
	read(`cp $x2 $prefix$c/`, String)
	read(`mkdir -p $prefix$c/out/`, String)

	f = open("$prefix$c/yasp.spec");
	lines = readlines(f)
	close(f)
	open("$prefix$c/yasp.spec", "w") do f
		for i in 1:length(lines)
			if i == 2
				write(f, "output_prefix $prefix$c/out/yasp\n")
			else
				write(f, lines[i]*"\n")
			end
		end
	end

	# repeat partMC simulations repeat times
	for i in 1:repeat
		if typeof(case) == InitialConditionTriangular
			s1 = generatePSDTriangular(case.Λ,case.δ,[case.Nt1, case.Dm],1)
			s2 = generatePSDTriangular(case.Λ,case.δ,[case.Nt2, case.Dm],2)
		else
			s1 = generatePSDLogNormal([case.Nt1, case.Dm, case.σ],1)
			s2 = generatePSDLogNormal([case.Nt2, case.Dm, case.σ],2)
		end

		path = "$prefix$c/out/"
		if verbose == true
			run(`partmc $prefix$c/yasp.spec`)
		else
			read(`partmc $prefix$c/yasp.spec`, String)
		end

		file = glob("*.nc",path)
		r = PartMCOutput[]
		for j = 2:6
			push!(r, readPSD(case, file[j],s1.De))
			k12[i,j-1] = r[j-1].k12
			ka[i,j-1] = r[j-1].ka
		end
	    push!(l,Simulation(case,s1,s2,r,k12,ka))
	end

	return l
end

end
